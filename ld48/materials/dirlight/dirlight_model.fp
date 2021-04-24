varying highp vec4 var_position;
varying mediump vec3 var_normal;
varying mediump vec2 var_texcoord0;
varying mediump vec4 var_light;

uniform mediump sampler2D tex0;
uniform mediump vec4 tint;
uniform mediump vec4 light_direction;
// uniform mediump vec4 ambient_color;

void main()
{
    // Pre-multiply alpha since all runtime textures already are
    vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
    vec4 color = texture2D(tex0, var_texcoord0.xy) * tint_pm;

    //
    float ambient_strength = 0.3;
    vec4 ambient_color = vec4(1.0, 1.0, 1.0, 1.0);
    vec4 ambient = ambient_strength * ambient_color;
    float diff_light = max(dot(var_normal, normalize(-light_direction.xyz)), 0.0);

    gl_FragColor = vec4(color.rgb * (diff_light + ambient.rgb), 1.0);
}

