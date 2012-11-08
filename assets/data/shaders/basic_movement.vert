attribute vec3 a_position;
attribute vec2 a_texCoord0;

uniform mat4 u_mvp;
uniform vec3 u_colour;
uniform vec3 u_ambient;

varying vec2 v_texcoords;
varying vec4 v_colour;

void main(void) {
	gl_Position = u_mvp * vec4(a_position, 1.0);
	v_texcoords = a_texCoord0;
	v_colour = vec4(u_colour, 1.0) * vec4(u_ambient, 1.0);
};