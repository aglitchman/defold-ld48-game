local M = {}

-- Variables
M.window_width = 2500
M.window_height = 1400
M.aspect_ratio = M.window_width/M.window_height
M.FOV = 42.5 -- Unreal Tournament FOV
M.NEAR = 0.1
M.FAR = 2000

-- Helpers
local IDENTITY_MAT4 = vmath.matrix4()
-- local FRONT = vmath.vector3(0, 0, -1)
-- local WORLD_UP = vmath.vector3(0, 1, 0)
M.FORWARD = vmath.vector3(0, 0, -1)
M.RIGHT = vmath.vector3(-1, 0, 0)

-- Camera vars
M.view_position = vmath.vector3(0, 0, 0)
M.view_front = vmath.vector3(0, 0, -1)
M.view_world_up = vmath.vector3(0, 1, 0)
M.bobbing_mat4 = vmath.matrix4()

function M.update_camera(yaw, pitch)
    local front = vmath.vector3()
    front.x = math.cos(math.rad(yaw)) * math.cos(math.rad(pitch))
    front.y = math.sin(math.rad(pitch))
    front.z = math.sin(math.rad(yaw)) * math.cos(math.rad(pitch))
    M.view_front = vmath.normalize(front)

    -- Re-calculate the Right and Up vector,
    -- plus normalize the vectors, because their length gets closer to 0 the more
    -- you look up or down which results in slower movement.
    M.view_right = vmath.normalize(vmath.cross(M.view_front, M.view_world_up)) 
    M.view_up = vmath.normalize(vmath.cross(M.view_right, M.view_front))
end

function M.update_window(w, h)
    M.window_width = w
    M.window_height = h
    M.aspect_ratio = w / h
end

function M.camera_view(with_bobbing)
    return vmath.matrix4_look_at(M.view_position, M.view_position + M.view_front, M.view_world_up) *
        (with_bobbing and M.bobbing_mat4 or IDENTITY_MAT4)
end

function M.camera_perspective()
    return vmath.matrix4_perspective(math.rad(M.FOV), M.aspect_ratio, M.NEAR, M.FAR)
end

return M