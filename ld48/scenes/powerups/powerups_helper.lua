local M = {}

-- vmath.quat_rotation_x(math.random()*10)
function M.spawn_blue(pos, rot)
    local obj_id = factory.create("/powerups#blue", pos, rot)
    msg.post(msg.url(nil, obj_id, "pickup_colobj"), "disable")
    go.set(msg.url(nil, obj_id, "shadow_caster"), "enabled", false)
    go.animate(msg.url(nil, obj_id, "model"), "tint", go.PLAYBACK_LOOP_PINGPONG, vmath.vector4(1.5), go.EASING_INQUAD, 3, math.random() * 1.5)
    return obj_id
end

return M