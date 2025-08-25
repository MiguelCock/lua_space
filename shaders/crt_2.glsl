extern vec2  iResolution;
extern number curvature;
extern number scanline;

vec2 barrel(vec2 uv, float k) {
    float r2 = dot(uv, uv);
    return uv + uv * r2 * k;
}

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 sc) {
    vec2 centered = uv * 2.0 - 1.0;
    vec2 distorted = barrel(centered, curvature);
    vec2 duv = (distorted * 0.5) + 0.5;

    
    if(duv.x < 0.0 || duv.x > 1.0 || duv.y < 0.0 || duv.y > 1.0) {
        return vec4(0.0, 0.0, 0.0, 1.0);
    }

    float ca = 0.0018;
    vec2 dir = (duv - 0.5);
    vec2 offs = normalize(dir + 1e-6) * ca;

    vec3 base;
    base.r = Texel(tex, duv + offs).r;
    base.g = Texel(tex, duv).g;
    base.b = Texel(tex, duv - offs).b;

    float sl = (sin(sc.y * 3.14159265) * 0.5 + 0.5);
    float scan = mix(1.0, sl * 0.85 + 0.15, scanline);
    base *= scan;

    return vec4(base, 1.0) * color;
}