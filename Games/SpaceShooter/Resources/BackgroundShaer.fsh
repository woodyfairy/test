

vec3 nrand3( vec2 co )
{
    vec3 a = fract( cos( co.x*8.3e-3 + co.y )*vec3(1.3e5, 4.7e5, 2.9e5) );
    vec3 b = fract( sin( co.x*0.3e-3 + co.y )*vec3(8.1e5, 1.0e5, 0.1e5) );
    vec3 c = mix(a, b, 0.5);
    return c;
}

void main( void )
{
    float time6 = time/6.;
    float time9 = time/9.;
    float time12 = time6/2.;
    float time18 = time9/2.;
    float time36 = time18/2.;
    
    float sinTime12 = sin(time12);
    float sinTime18 = sin(time18);
    float sinTime36 = sin(time36);
    
    vec2 uv0 = gl_FragCoord.xy / size.xy;
    vec2 uv = 2. * uv0 - 1.;
    //vec2 uv = gl_FragCoord.xy / size.xy;
    vec2 uvs = uv * size.xy / max(size.x, size.y);
    vec3 p = vec3(uvs / 4., 0) + vec3(1., -1.3, 0.);
    p += .2 * vec3(sinTime18, sinTime12, sinTime36);//.2 * vec3(sin(time / 16.), sin(time / 12.),  sin(time / 128.));
    
    vec3 p2 = vec3(uvs / (4.+sin(time9)*0.2+0.2+sin(time6)*0.3+0.4), 1.5) + vec3(2., -1.3, -1.);//vec3(uvs / (4.+sin(time*0.11)*0.2+0.2+sin(time*0.15)*0.3+0.4), 1.5) + vec3(2., -1.3, -1.);
    p2 += 0.25 * vec3(sinTime18, sinTime12,  sinTime36);//0.25 * vec3(sin(time / 16.), sin(time / 12.),  sin(time / 128.));
    
    p += vec3(-offset.xy * 0.0005, 0);
    p2 += vec3(-offset.xy * 0.0005, 0);
    
    
    //Let's add some stars
    //Thanks to http://glsl.heroku.com/e#6904.0
    vec2 seed = p.xy * 2.0;
    seed = floor(seed * size.x);
    vec3 rnd = nrand3( seed );
    vec4 starcolor = vec4(pow(rnd.y,40.0));
    
    //Second Layer
    vec2 seed2 = p2.xy * 2.0;
    seed2 = floor(seed2 * size.x);
    vec3 rnd2 = nrand3( seed2 );
    starcolor += vec4(pow(rnd2.y,40.0));
    
    
    //vec3 col = vec4(uv0,0.5+0.5*sin(time * 0.1),1.0).xyz;
    //vec3 col = vec4(1.-sin(time * 0.1), 1.-sin(time * 0.1 + 2.0944), 1.-sin(time * 0.1 + 4.1888),1.0).xyz;
    vec3 col = vec4(1.-sinTime12, 1.-sin(time12 + 2.0944)*uv0.x, 1.-sin(time12 + 4.1888)*(1.-uv0.x), 1.0).xyz;
    
    
    //gl_FragColor = vec4(col , 1.0);
    //gl_FragColor = vec4(min(starcolor.xyz, col) , 1.0);
    gl_FragColor = vec4((starcolor.xyz + vec3(0.05,0.02,0.07)) * 0.8 * col, 1.0);
}