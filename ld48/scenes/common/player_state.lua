local s = {}

function s.reset()
    -- Variables
    s.pos = vmath.vector3(0, 100, 0)
    s.eye_pos = vmath.vector3(0, 70, 0)
    s.yaw = 270
    s.pitch = 0
    s.prev_yaw = s.yaw
    s.prev_pitch = s.pitch

    s.key_state = s.key_state or {}
    s.key_state.forward = false
    s.key_state.backward = false
    s.key_state.step_left = false
    s.key_state.step_right = false
    s.key_state.fire = false -- NOT USED

    -- Bobbing
    s.dist_walked = 0
    s.prev_dist_walked = 0

    -- s.cursor_locked = false

    -- Config
    s.mouse_sensitivity = 0.3

    -- Weapon
    -- NOT USED YET
    s.weapon_state = s.weapon_state or {}
    s.weapon_state.energy = 99
    s.weapon_state.fire_rate = 4
    s.weapon_state.power_usage = 1
    s.weapon_state.aim_penalty = 0
    s.weapon_state.aim_penalty_upper = 100
end

function s.update_aim(dt)
    local ws = s.weapon_state

    local dist = math.abs(s.dist_walked - s.prev_dist_walked)
    ws.aim_penalty = ws.aim_penalty + dist * 50 * dt

    ws.aim_penalty = math.max(0, ws.aim_penalty - math.min(20 * (dt * 60), ws.aim_penalty / 5 * (dt * 60)))

    ws.aim_penalty = math.min(ws.aim_penalty, ws.aim_penalty_upper)
end

s.reset()

return s