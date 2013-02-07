attribute vec3 a_position;
attribute vec3 a_colour;

uniform mat4 u_mv;
uniform float u_point;

varying vec3 v_colour;

void main() {
    vec4 position = u_mv * vec4(a_position, 1.0);
    v_colour = a_colour;

    gl_Position = position;
	gl_PointSize = u_point;
}