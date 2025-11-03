#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
uniform float iTime;
uniform sampler2D iChannel1;
#define mainImage main

#define V vec2(0.,1.)
#define PI 3.14159265
#define HUGE 1E9
#define VHSRES vec2(openfl_TextureSize.x, openfl_TextureSize.y)
#define saturate(i) clamp(i,0.,1.)
#define lofi(i,d) floor(i/d)*d
#define validuv(v) (abs(v.x-0.5)<0.5&&abs(v.y-0.5)<0.5)

uniform float sat;
uniform float wiggle;

float hash( vec2 _v ){
  return fract( sin( dot( _v, vec2( 89.44, 19.36 ) ) ) * 22189.22 );
}

float iHash( vec2 _v, vec2 _r ){
  float h00 = hash( vec2( floor( _v * _r + vec2( 0.0, 0.0 ) ) / _r ) );
  float h10 = hash( vec2( floor( _v * _r + vec2( 1.0, 0.0 ) ) / _r ) );
  float h01 = hash( vec2( floor( _v * _r + vec2( 0.0, 1.0 ) ) / _r ) );
  float h11 = hash( vec2( floor( _v * _r + vec2( 1.0, 1.0 ) ) / _r ) );
  vec2 ip = vec2( smoothstep( vec2( 0.0, 0.0 ), vec2( 1.0, 1.0 ), mod( _v*_r, 1. ) ) );
  return ( h00 * ( 1. - ip.x ) + h10 * ip.x ) * ( 1. - ip.y ) + ( h01 * ( 1. - ip.x ) + h11 * ip.x ) * ip.y;
}

float noise( vec2 _v ){
  float sum = 0.;
  for( int i=1; i<9; i++ )
  {
    sum += iHash( _v + vec2( i ), vec2( 2. * pow( 2., float( i ) ) ) ) / pow( 2., float( i ) );
  }
  return sum;
}


float v2random( vec2 uv ) {
  return flixel_texture2D( bitmap, mod( uv, vec2( 1.0 ) ) ).x;
}

mat2 rotate2D( float t ) {
  return mat2( cos( t ), sin( t ), -sin( t ), cos( t ) );
}

vec3 rgb2yiq( vec3 rgb ) {
  return mat3( 0.299, 0.596, 0.211, 0.587, -0.274, -0.523, 0.114, -0.322, 0.312 ) * rgb;
}

vec3 yiq2rgb( vec3 yiq ) {
  return mat3( 1.000, 1.000, 1.000, 0.956, -0.272, -1.106, 0.621, -0.647, 1.703 ) * yiq;
}

#define SAMPLES 6

vec3 vhsTex2D( vec2 uv, float rot ) {
  if ( validuv( uv ) ) {
    vec3 yiq = vec3( 0.0 );
    for ( int i = 0; i < SAMPLES; i ++ ) {
      yiq += (
        rgb2yiq( flixel_texture2D( bitmap, uv - vec2( float( i ), 0.0 ) / VHSRES ).xyz ) *
        vec2( float( i ), float( SAMPLES - 1 - i ) ).yxx / float( SAMPLES - 1 )
      ) / float( SAMPLES ) * 2.0;
    }
    if ( rot != 0.0 ) { yiq.yz = rotate2D( rot ) * yiq.yz; }
    return yiq2rgb( yiq );
  }
  return vec3( 0.1, 0.1, 0.1 );
}

void main() {
  vec2 uv = fragCoord.xy / openfl_TextureSize.xy / openfl_TextureSize.xy * VHSRES;
  float time = iTime;

  vec2 uvn = uv;
  vec3 col = vec3( 0.0, 0.0, 0.0 );

  // tape wave
  uvn.x += ( v2random( vec2( uvn.y / 10.0, time / 10.0 ) / 1.0 ) - 0.5 ) / VHSRES.x * 1.0;
  uvn.x += ( v2random( vec2( uvn.y, time * 10.0 ) ) - 0.5 ) / VHSRES.x * 1.0;
  uvn.x += ( noise( vec2( uvn.y * 100.0, iTime * 10.0 ) ) - 0.5 ) * wiggle;

  // tape crease
  float tcPhase = smoothstep( 0.9, 0.96, sin( uvn.y * 8.0 - ( time + 0.14 * v2random( time * vec2( 0.67, 0.59 ) ) ) * PI * 1.2 ) );
  float tcNoise = smoothstep( 0.3, 1.0, v2random( vec2( uvn.y * 4.77, time ) ) );
  float tc = tcPhase * tcNoise;
  uvn.x = uvn.x - tc / VHSRES.x * 8.0;

  // switching noise
  float snPhase = smoothstep( 6.0 / VHSRES.y, 0.0, uvn.y );
  uvn.y += snPhase * 0.3;
  uvn.x += snPhase * ( ( v2random( vec2( uv.y * 100.0, time * 10.0 ) ) - 0.5 ) / VHSRES.x * 24.0 );

  // fetch
  col = vhsTex2D( uvn, tcPhase * 0.2 + snPhase * 2.0 );

  // crease noise
  /*float cn = tcNoise * ( 0.3 + 0.7 * tcPhase );
  if ( 0.29 < cn ) {
    vec2 uvt = ( uvn + V.yx * v2random( vec2( uvn.y, time ) ) ) * vec2( 0.1, 1.0 );
    float n0 = v2random( uvt );
    float n1 = v2random( uvt + V.yx / VHSRES.x );
    if ( n1 < n0 ) {
      col = mix( col, 2.0 * V.yyy, pow( n0, 10.0 ) );
    }
  }*/

  // ac beat
  col *= 1.0 + 0.1 * smoothstep( 0.4, 0.6, v2random( vec2( 0.0, 0.1 * ( uv.y + time * 0.2 ) ) / 10.0 ) );

  // color noise
  col *= sat + 0.1 * flixel_texture2D( iChannel1, mod( uvn * vec2( 1.0, 1.0 ) + time * vec2( 5.97, 4.45 ), vec2( 1.0 ) ) ).xyz;
  col = saturate( col );

  gl_FragColor = vec4( col, flixel_texture2D(bitmap, uv).w);
}