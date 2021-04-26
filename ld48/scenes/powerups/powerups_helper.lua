local lume = require("ld48.app.lume")

local M = {
    PER_HARVESTER = 20
}

local MAX_POWERUPS = 200

function M.reset()
    M.list = {}
end

M.reset()

function M.can_spawn()
    return #M.list < MAX_POWERUPS
end

-- vmath.quat_rotation_x(math.random()*10)
function M.spawn_blue(pos, rot, target)
    local obj_id = factory.create("/powerups#blue", pos, rot)
    if target then
        msg.post(msg.url(nil, obj_id, "pickup_colobj"), "disable")
    else
        msg.post(msg.url(nil, obj_id, "target_colobj"), "disable")
    end
    go.set(msg.url(nil, obj_id, "shadow_caster"), "enabled", not target)
    go.animate(msg.url(nil, obj_id, "model"), "tint", go.PLAYBACK_LOOP_PINGPONG, vmath.vector4(1.5), go.EASING_INQUAD, 3, math.random() * 1.5)
    table.insert(M.list, obj_id)
    return obj_id
end

function M.free_from_harvester(obj_id)
    local new_id = M.spawn_blue(go.get_world_position(obj_id), go.get_rotation(obj_id), false)
    go.delete(obj_id, true)
    lume.remove(M.list, obj_id)
    return new_id
end

function M.destroy(obj_id)
    go.delete(obj_id, true)
    lume.remove(M.list, obj_id)
end

return M