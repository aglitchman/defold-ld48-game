varying highp vec4 var_position;
varying mediump vec3 var_normal;
varying mediump vec2 var_texcoord0;
varying mediump vec4 var_light;

uniform mediump sampler2D tex0;
uniform mediump vec4 tint;
uniform mediump vec4 light_direction;
uniform mediump vec4 ambient_color;
uniform mediump vec4 diffuse_light;

void main()
{
    // Pre-multiply alpha since all runtime textures already are
    vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
    vec4 color = texture2D(tex0, var_texcoord0.xy) * tint_pm;

    //
    float ambient_strength = ambient_color.w;
    vec3 ambient = ambient_strength * ambient_color.rgb;
    float diff_light = max(dot(var_normal, normalize(-light_direction.xyz)), 0.0) * diffuse_light.w;

    gl_FragColor = vec4(color.rgb * min(diff_light + ambient, vec3(1.0)), 1.0);
}

