local s = {
    DEBUG = false
}

function s.reset()
    -- Variables
    s.pos = vmath.vector3(0, 100, 200)
    s.eye_pos = vmath.vector3(0, 70, 0)
    s.yaw = 270
    s.pitch = -15
    s.prev_yaw = s.yaw
    s.prev_pitch = s.pitch

    s.key_state = s.key_state or {}
    s.key_state.forward = false
    s.key_state.backward = false
    s.key_state.step_left = false
    s.key_state.step_right = false

    -- Bobbing
    s.dist_walked = 0
    s.prev_dist_walked = 0

    -- s.cursor_locked = false

    -- Config
    s.mouse_sensitivity = 0.21

    -- Weapon
    s.weapon_state = s.weapon_state or {}
    s.weapon_state.present = false
    s.weapon_state.holo = false
    s.weapon_state.ammo_count = 50
    s.weapon_state.max_ammo = 99
    s.weapon_state.aim_penalty = 0
    s.weapon_state.aim_penalty_upper = 100

    -- Inventory
    s.inventory = s.inventory or {}
    s.inventory.blue = 0

    --
    s.power_plant = s.power_state or {}
    s.power_plant.energy = 1
    s.power_plant.max_energy = 200
    s.power_plant.timeout = 3

    -- Tutorial
    s.tutorial_step = 0
end

function s.update_aim(frame_dt)
    local ws = s.weapon_state
    local frame_dist = math.abs(s.dist_walked - s.prev_dist_walked)

    local dt = math.min(frame_dt, 0.0166666)
    local dd = frame_dt
    while dd > 0.00001 do
        dt = math.min(dt, dd)
        dd = dd - dt
        local dist = frame_dist / frame_dt * dt
        ws.aim_penalty = ws.aim_penalty + dist * 50 * dt
        ws.aim_penalty = math.max(0, ws.aim_penalty - math.min(20 * (dt * 60), ws.aim_penalty / 5 * (dt * 60)))
        ws.aim_penalty = math.min(ws.aim_penalty, ws.aim_penalty_upper)
    end
end

function s.add_blue()
    s.inventory.blue = math.min(999, s.inventory.blue + 1)
end

function s.remove_blue(amount)
    if s.inventory.blue >= amount then
        s.inventory.blue = s.inventory.blue - amount
        return true
    end
    return false
end

s.reset()

return s
