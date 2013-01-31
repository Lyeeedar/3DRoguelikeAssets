uniform sampler2D u_texture;
varying vec4 v_colour;

void main() 
{
   gl_FragColor = texture2D(u_texture, gl_PointCoord) * v_colour;
}