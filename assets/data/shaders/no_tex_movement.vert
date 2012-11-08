attribute vec3 a_position;

uniform mat4 u_mvp;
uniform vec3 u_colour;
uniform vec3 u_ambient;

varying vec4 v_colour;

void main(void) {
	gl_Position = u_mvp * vec4(a_position, 1.0);
	v_colour = vec4(u_colour, 1.0) * vec4(u_ambient, 1.0);
};