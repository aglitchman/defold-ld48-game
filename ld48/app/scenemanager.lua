local M = {}

M._init_seq = 0
M.receiver = nil
M.scenes = {}

local is_loading_scene = nil
local is_loading_popup = nil

M.current_scene = nil
M.current_popup = nil

local LOAD_MSG = hash("async_load")
M.load_timestamp = 0

M.debug_text = ""

--
-- PRIVATE API
--

local function stop_scene(scene)
    msg.post(M.current_scene.scene_obj, hash("release_input_focus"))
    msg.post(M.current_scene.scene_proxy, hash("set_time_step"), {factor = 0, mode = 0})
end

local function resume_scene(scene)
    msg.post(M.current_scene.scene_proxy, hash("set_time_step"), {factor = 1, mode = 0})
    msg.post(M.current_scene.scene_obj, hash("acquire_input_focus"))
end

local function load_res_or_scene_proxy()
    if is_loading_scene.load_res then
        M.load_timestamp = socket.gettime()
        msg.post(is_loading_scene.res_proxy, LOAD_MSG)
    else
        if M.current_scene ~= nil then
            msg.post(M.current_scene.scene_proxy, hash("unload"))
        else
            M.load_timestamp = socket.gettime()
            msg.post(is_loading_scene.scene_proxy, LOAD_MSG)
        end
    end
end

--
-- PUBLIC API
--

function M.get_scene(name)
    local name_hash = name
    if type(name) == "string" then
        name_hash = hash(name)
    end
    local scene = M.scenes[name_hash]
    assert(scene ~= nil)
    return scene
end

--- Загрузить сцену
-- TODO remove popup M.current_popup
-- @param name Строка или хэш
function M.load_scene(name, args)
    print("Load scene: " .. name)

    assert(is_loading_scene == nil)

    local scene = M.get_scene(name)

    if M.current_scene == scene then
        print("WARN: scene already loaded")
    end

    if M.current_scene ~= nil then
        stop_scene(M.current_scene)
    end

    if M.current_popup ~= nil then
        stop_scene(M.current_popup)
    end

    is_loading_scene = scene
    is_loading_scene.scene_args = args

    msg.post(M.receiver, hash("_load_scene"))
    return true
end

--- Загрузить сцену и отобразить как поп-ап
-- @param name Строка или хэш
function M.popup_scene(name, args)
    print("Popup scene: " .. name)

    assert(is_loading_scene == nil)
    assert(is_loading_popup == nil)

    local scene = M.get_scene(name)

    if M.current_scene == scene then
        error("FATAL: collection already loaded as scene")
    end

    if M.current_scene ~= nil then
        stop_scene(M.current_scene)
    end

    is_loading_popup = scene
    is_loading_popup.scene_args = args

    msg.post(M.receiver, hash("_load_popup"))
    return true
end

function M.close_popup()
    assert(M.current_popup ~= nil)

    msg.post(M.current_popup.scene_proxy, hash("unload"))
    M.current_popup = nil

    if M.current_scene ~= nil then
        resume_scene(M.current_scene)
    end
end

function M._add_scene(scene)
    M.scenes[scene.name] = scene
end

function M._load_scene()
    assert(is_loading_scene ~= nil)

    if M.current_scene and M.current_scene.hidden then
        M._transition_fade_in_complete()
    else
        msg.post(M.transition, hash("fade_in"))
    end
end

function M._load_popup()
    assert(is_loading_popup ~= nil)
    assert(not is_loading_popup.load_res)

    M.load_timestamp = socket.gettime()
    msg.post(is_loading_popup.scene_proxy, LOAD_MSG)
end

function M._transition_fade_in_complete()
    assert(is_loading_scene ~= nil)

    load_res_or_scene_proxy()
end

function M._transition_fade_out_complete()
    msg.post(M.current_scene.scene_obj, hash("acquire_input_focus"))
    msg.post(M.current_scene.scene_obj, hash("fade_out_complete"))
end

function M._proxy_loaded()
    local dts = socket.gettime() - M.load_timestamp
    M.load_timestamp = 0
    M.debug_text = M.debug_text .. string.format(" / %.2f", dts)

    if is_loading_popup then
        local popup = is_loading_popup
        M.current_popup = is_loading_popup
        is_loading_popup = nil

        if defos and sys.get_engine_info().is_debug then
            defos.set_window_title(sys.get_config("project.title") .. (M.current_scene and (" / " .. M.current_scene.name) or "") .. " / " .. popup.name)
        end

        msg.post(popup.scene_proxy, hash("set_time_step"), {factor = 1, mode = 0})
        msg.post(popup.scene_proxy, hash("enable"))

        msg.post(popup.scene_obj, hash("acquire_input_focus"))
        msg.post(popup.scene_obj, hash("fade_out_complete"))

        return
    end

    assert(is_loading_scene ~= nil)

    if is_loading_scene.load_res then
        -- После загрузки сцены с ресурсами
        is_loading_scene.load_res = false
        load_res_or_scene_proxy()
        return
    end

    if M.current_scene ~= nil then
        -- ???
    end

    local scene = is_loading_scene
    M.current_scene = is_loading_scene
    is_loading_scene = nil

    if defos and sys.get_engine_info().is_debug then
        defos.set_window_title(sys.get_config("project.title") .. " / " .. scene.name)
    end

    msg.post(scene.scene_proxy, hash("set_time_step"), {factor = 1, mode = 0})
    msg.post(scene.scene_proxy, hash("enable"))

    if scene.hidden then
        M._transition_fade_out_complete()
    else
        msg.post(M.transition, hash("fade_out"))
    end
end

function M._proxy_unloaded()
    if M.current_popup ~= nil then
        msg.post(M.current_popup.scene_proxy, hash("unload"))
        M.current_popup = nil
    else
        M.load_timestamp = socket.gettime()
        msg.post(is_loading_scene.scene_proxy, LOAD_MSG)
    end
end

return M