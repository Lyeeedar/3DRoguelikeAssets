uniform sampler2D u_texture;
varying vec3 v_colour;
varying vec2 v_texCoords;

void main() 
{
	if (v_colour == vec3(-13, -13, -13)) {
		discard;
	}

   gl_FragColor = texture2D(u_texture, v_texCoords) * vec4(v_colour, 1.0f);
}