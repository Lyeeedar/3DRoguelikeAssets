#ifdef GL_ES
	precision mediump float;

#endif

varying vec4 v_color;
varying vec2 v_texCoords;
uniform sampler2D u_texture;

float unpackHalf (vec2 colour)
{
	return colour.x + (colour.y / 255.0);
}

void main() {

	vec4 colour = texture2D(u_texture, v_texCoords);
	float depth = unpackHalf(colour.ba);
    gl_FragColor.rgb = vec3(depth, depth, depth);
    gl_FragColor.a = 1.0;
}