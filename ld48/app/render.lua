local M = {}

M.ASPECT_RATIO = 2500/1400
M.FOV = 42.5 -- Unreal Tournament FOV
M.FRONT = vmath.vector3(0, 0, -1)
M.WORLD_UP = vmath.vector3(0, 1, 0)
M.POSITION = vmath.vector3(0, 0, 0)
M.NEAR = 0.1
M.FAR = 2000

function M.camera_view()
    return vmath.matrix4_look_at(M.POSITION, M.POSITION + M.FRONT, M.WORLD_UP);
end

function M.camera_perspective()
    return vmath.matrix4_perspective(M.FOV / 180 * math.pi, M.ASPECT_RATIO, M.NEAR, M.FAR)
end

return M