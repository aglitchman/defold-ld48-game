local M = {}

function M.reset()
    -- Variables
    M.yaw = -90
    M.pitch = 0
    -- M.cursor_locked = false

    -- Config
    M.mouse_sensitivity = 0.3
end

M.reset()

return M