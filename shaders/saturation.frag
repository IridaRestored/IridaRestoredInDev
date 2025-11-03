#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
uniform float iTime;
uniform float sat;
#define mainImage main

void main()
{
    vec2 uv = fragCoord.xy / openfl_TextureSize.xy;
    vec3 col = flixel_texture2D(bitmap, uv).xyz;
    
    // positive = more saturation
    // negative = less saturation
    // 0.0 = unchanged
    // -1.0 = grayscale
    // < -1.0 = color inversion
        
    float average = (col.x + col.y + col.z) / 3.0;
    float xd = average - col.x;
    float yd = average - col.y;
    float zd = average - col.z;
    col = mix(vec3(average), col, sat);
    
    gl_FragColor = vec4(col, flixel_texture2D(bitmap, uv).w);
}