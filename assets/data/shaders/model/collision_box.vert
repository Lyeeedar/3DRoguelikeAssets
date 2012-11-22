attribute vec3 a_position;

uniform mat4 u_mvp;

varying vec4 v_colour;

void main(void) {
	gl_Position = u_mvp * vec4(a_position, 1.0);
	v_colour = vec4(1.0, 0.0, 0.0, 1.0);
};