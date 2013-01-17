#ifdef GL_ES
    precision mediump float;
#endif

varying vec4 v_color;
varying vec2 v_texCoords;
uniform sampler2D u_texture;
uniform float u_threshold;

void main() {

	vec4 colour = texture2D(u_texture, v_texCoords);
	if (colour.x+colour.y+colour.z > u_threshold)
	{

	}
	else
	{
		colour = vec4(0.0, 0.0, 0.0, 0.0);
	}
    gl_FragColor = v_color * colour;
}