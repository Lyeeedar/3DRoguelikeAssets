attribute vec3 a_position;
attribute vec2 a_texcoords;

uniform mat4 u_mvp;
uniform vec3 u_colour;

varying vec2 v_texcoords;
varying vec4 v_colour;

void main(void) {
	gl_Position = u_mvp * vec4(a_position, 1.0);
	v_texcoords = a_texcoords;
	v_colour = vec4(u_colour, 1.0);
};