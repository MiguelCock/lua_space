extern number iTime;
extern number curvature;    // 0.0 .. ~0.15 typical
extern number vignette;     // 0.0 .. 1.5
extern number scanline;     // 0.0 .. 1.0 (strength)
extern number mask;         // 0.0 .. 1.0 (phosphor triad strength)
extern number noise;        // 0.0 .. 0.2

// Barrel distortion (simple) on normalized uv centered at 0
vec2 barrel(vec2 uv, float k) {
    // uv expected in [-1,1]
    float r2 = dot(uv, uv);
    return uv + uv * r2 * k;
}

// Simple pseudo-random hash
float hash(vec2 p){
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5,183.3)));
    return fract(sin(p.x + p.y) * 43758.5453);
}

// Main post-process
vec4 effect(vec4 color, Image tex, vec2 uv, vec2 sc) {
    // uv in [0,1], sc in pixels (screen)

    // Convert to -1..1 for distortion
    vec2 centered = uv * 2.0 - 1.0;
    vec2 distorted = barrel(centered, curvature);
    vec2 duv = (distorted * 0.5) + 0.5; // back to 0..1

    // If outside, draw black bezel fade
    if(duv.x < 0.0 || duv.x > 1.0 || duv.y < 0.0 || duv.y > 1.0) {
        return vec4(0.0, 0.0, 0.0, 1.0);
    }

    // Subtle chromatic aberration by offsetting channels
    float ca = 0.0018; // strength of chromatic offset
    vec2 dir = (duv - 0.5);
    vec2 offs = normalize(dir + 1e-6) * ca;

    vec3 base;
    base.r = Texel(tex, duv + offs).r;
    base.g = Texel(tex, duv).g;
    base.b = Texel(tex, duv - offs).b;

    // Scanlines (based on final screen Y in pixels)
    float sl = (sin(sc.y * 3.14159265) * 0.5 + 0.5); // 1 line per pixel row
    float scan = mix(1.0, sl * 0.85 + 0.15, scanline);
    base *= scan;

    // Phosphor mask (RGB triad across X pixels)
    float triad = fract(sc.x / 1.0); // per pixel
    float mR = step(0.0, triad) * step(triad, 1.0); // all pixels contribute; we'll stripe via modulo
    // Better: use modulo by 3 to alternate RGB
    float stripe = mod(floor(sc.x), 3.0);
    vec3 maskRGB = vec3(stripe == 0.0 ? 1.0 : 0.6,
                        stripe == 1.0 ? 1.0 : 0.6,
                        stripe == 2.0 ? 1.0 : 0.6);
    base = mix(base, base * maskRGB, mask);

    // Vignette based on distorted coords (keeps corners darker)
    float vig = 1.0 - dot(distorted, distorted); // ~1 center, ~0 edges
    vig = pow(clamp(vig, 0.0, 1.0), mix(0.8, 1.5, vignette));
    base *= vig;

    // Gentle grain
    float n = (hash(sc + iTime) - 0.5) * 2.0; // -1..1
    base += n * noise;

    return vec4(base, 1.0) * color;
}