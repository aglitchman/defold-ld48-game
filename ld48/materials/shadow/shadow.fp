varying highp vec4 position;
varying mediump vec2 var_texcoord0;

uniform lowp vec4 tint;

void main()
{
    lowp vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);

    mediump vec2 uvm = var_texcoord0.xy - 0.5;
    mediump float glow = clamp(1.0 - ((dot(uvm, uvm) * 4.0)), 0.0, 1.0);
    // #if _CFXR_GLOW_POW_P2
    // glow = pow(glow, 2);
    // #elif _CFXR_GLOW_POW_P4
    // glow = pow(glow, 4);
    // #elif _CFXR_GLOW_POW_P8
    // glow = pow(glow, 8);
    // #endif
    glow = clamp(mix(0.0, 0.6, glow), 0.0, 10.0) * clamp(glow * 30.0, 0.0, 1.0);

    lowp vec4 color_pm = tint_pm * glow;

    gl_FragColor = color_pm;
}
