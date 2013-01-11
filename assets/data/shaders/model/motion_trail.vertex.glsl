attribute vec3 a_position;
attribute float a_texCoord;

uniform mat4 u_mv;
uniform vec4 u_colour;

varying float v_texCoord;
varying vec4 v_colour;

void main(void) {
	gl_Position = u_mv * vec4(a_position, 1.0);
	v_colour = u_colour;
	v_texCoord = a_texCoord;
};