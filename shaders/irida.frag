#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;

#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

#define rot(x) mat2(cos(x+vec4(0,11,33,0)))
#define ROT(p,axis,t) mix(axis*dot(p,axis),p,cos(t))+sin(t)*cross(p,axis)
#define H(h)  (cos(h + vec3(15,11,16.5)) * 0.6 + 0.5)
#define H2(h) (cos(h*h/3. + vec3(5,2,2)) * 0.7 + 0.2)
#define M(c)  log(1.0 + c)

#define iterations 12   // reducido de 17
#define formuparam 0.53
#define volsteps 12     // reducido de 20
#define stepsize 0.15   // pasos más grandes

#define zoom   0.8
#define tile   0.85
#define speed  0.000
#define brightness 0.0015
#define darkmatter 0.3
#define distfading 0.73
#define saturation 0.85

void mainVR(out vec4 fragColor, in vec2 fragCoord, in vec3 ro, in vec3 rd) {
    vec3 from = ro;
    float s = 0.1, fade = 1.0;
    vec3 v = vec3(0.0);
    
    for (int r = 0; r < volsteps; r++) {
        vec3 p = from + s * rd * 0.5;
        p = abs(vec3(tile) - mod(p, vec3(tile * 2.0)));

        float pa = 0.0, a = 0.0;
        for (int i = 0; i < iterations; i++) {
            p = abs(p) / dot(p, p) - formuparam;
            p.xy *= rot(iTime * 0.05);
            a += abs(length(p) - pa);
            pa = length(p);
        }

        float dm = max(0.0, darkmatter - a*a*0.001);
        a *= a*a;
        if (r > 4) fade *= 1.3 - dm;
        v += fade;
        v += vec3(s, s*s, s*s*s*s) * a * brightness * fade;
        fade *= distfading;
        s += stepsize;
    }
    v = mix(vec3(length(v)), v, saturation);
    fragColor = vec4(v * 0.08, 1.0);
}

float happy_star(vec2 uv, float anim) {
    uv = abs(uv);
    vec2 pos = min(uv.xy / uv.yx, anim);
    float p = (2.0 - pos.x - pos.y);
    return (2.0 + p*(p*p - 1.5)) / (uv.x + uv.y);
}

void mainImage() {
    vec2 uv = fragCoord / iResolution - 0.5;
    vec2 uv2 = uv;
    uv.y *= iResolution.y / iResolution.x;

    vec3 dir = vec3(uv * zoom, 1.0);
    float t2 = iTime * 0.1 + ((0.25 + 0.05 * sin(iTime * 0.1)) / (length(uv.xy) + 0.07)) * 2.2;
    float si = sin(t2), co = cos(t2);
    mat2 ma = mat2(co, si, -si, co);

    vec3 c = vec3(0.0);
    vec4 rd = normalize(vec4(fragCoord - 0.5 * iResolution, iResolution.y, iResolution.y * 2.0)) * 80.0;

    float totdist = 0.0, t = 0.7;
    for (float i = 0.0; i < 100.0; i++) { // reducido de 200
        vec4 p = vec4(rd * totdist);
        p.xyz += vec3(0, 0, -1.7);
        p.yzw = ROT(p.xyz, normalize(vec3(sin(t/2.0), sin(t), cos(t/3.0))), t);

        float sc = 1.1;
        p.xy *= ma;
        vec4 w = p;

        for (float j = 0.0; j < 5.0; j++) { // reducido de 7
            p = abs(p) * 0.77;
            float dotp = max(1.0 / dot(w, w), 0.1);
            sc *= dotp;
            p = p * dotp - 0.42;
            w = 0.75 * p - 0.025;
        }

        float dist = abs(length(p) - 0.025) / sc;
        float stepsize2 = dist / 15.0;
        totdist += stepsize2;

        c += 3e-3 * H2(atan(p.w, p.z)) +
             mix(vec3(1.0), H(M(sc)), 0.95) * 0.03 * exp(-i*i*stepsize2*stepsize2*8e3);
    }
    c = 1.0 - exp(-c*c);

    vec3 from = vec3(1.0, 0.9, 1.5);
    dir += c;
    mainVR(fragColor, fragCoord, from, dir);
    fragColor *= vec4(c, 1.0);

    uv *= 2.0 * (cos(iTime * 2.0) - 2.5);
    float anim = sin(iTime * 12.0) * 0.1 + 1.0;
    fragColor *= vec4(happy_star(uv, anim) * vec3(0.35, 1.0, 1.55), 1.0);
}
