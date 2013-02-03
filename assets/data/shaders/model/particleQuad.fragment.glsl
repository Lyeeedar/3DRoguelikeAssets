uniform sampler2D u_texture;
varying vec3 v_colour;
varying vec2 v_texCoords;

void main() 
{
   gl_FragColor = texture2D(u_texture, v_texCoords) * vec4(v_colour, 1.0f);
}