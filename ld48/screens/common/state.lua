local M = {}

function M.reset()
    -- Variables
    M.pos = vmath.vector3(0, 70, 0)
    M.yaw = -90
    M.pitch = 0

    M.key_state = M.key_state or {}
    M.key_state.forward = false
    M.key_state.backward = false
    M.key_state.step_left = false
    M.key_state.step_right = false

    -- Bobbing
    M.dist_walked = 0
    M.prev_dist_walked = 0

    -- M.cursor_locked = false

    -- Config
    M.mouse_sensitivity = 0.3
end

M.reset()

return M