local M = {}

-- Variables
M.WINDOW_WIDTH = 2500
M.WINDOW_HEIGHT = 1400
M.ASPECT_RATIO = M.WINDOW_WIDTH/M.WINDOW_HEIGHT
M.FOV = 42.5 -- Unreal Tournament FOV
M.NEAR = 0.1
M.FAR = 2000

-- Helpers
-- local FRONT = vmath.vector3(0, 0, -1)
-- local WORLD_UP = vmath.vector3(0, 1, 0)

-- Camera vars
M.POSITION = vmath.vector3(0, 0, 0)
M.FRONT = vmath.vector3(0, 0, -1)
M.WORLD_UP = vmath.vector3(0, 1, 0)

function M.update_camera(yaw, pitch)
    local front = vmath.vector3()
    front.x = math.cos(math.rad(yaw)) * math.cos(math.rad(pitch))
    front.y = math.sin(math.rad(pitch))
    front.z = math.sin(math.rad(yaw)) * math.cos(math.rad(pitch))
    M.FRONT = vmath.normalize(front)

    -- Re-calculate the Right and Up vector
    M.RIGHT = vmath.normalize(vmath.cross(M.FRONT, M.WORLD_UP)) -- normalize the vectors, because their length
                                                                -- gets closer to 0 the more you look up or down
                                                                -- which results in slower movement.
    M.UP = vmath.normalize(vmath.cross(M.RIGHT, M.FRONT))
end

function M.update_window(w, h)
    M.WINDOW_WIDTH = w
    M.WINDOW_HEIGHT = h
    M.ASPECT_RATIO = w / h
end

function M.camera_view()
    return vmath.matrix4_look_at(M.POSITION, M.POSITION + M.FRONT, M.WORLD_UP);
end

function M.camera_perspective()
    return vmath.matrix4_perspective(math.rad(M.FOV), M.ASPECT_RATIO, M.NEAR, M.FAR)
end

return M