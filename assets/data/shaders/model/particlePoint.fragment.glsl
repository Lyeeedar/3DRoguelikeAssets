uniform sampler2D u_texture;
varying vec3 v_colour;

void main() 
{
   gl_FragColor = texture2D(u_texture, gl_PointCoord) * vec4(v_colour, 1.0f);
}