local M = {}

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
    return obj_id
end

function M.free_from_harvester(obj_id)
    local new_id = M.spawn_blue(go.get_world_position(obj_id), go.get_rotation(obj_id), false)
    go.delete(obj_id, true)
    return new_id
end

return M