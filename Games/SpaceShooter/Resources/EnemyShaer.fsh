
void main( void )
{
    vec4 color = SKDefaultShading();//texture2D(u_texture, v_tex_coord.xy);
    gl_FragColor = vec4(color.rgb + vec3(0.2)*color.a, color.a);
}