attribute vec3 a_position;
attribute vec3 a_colour;

uniform mat4 u_mv;
uniform vec3 u_cam;

varying vec3 v_colour;

void main() {
    vec4 position = u_mv * vec4(a_position, 1.0);
    v_colour = a_colour;
    gl_PointSize = 200-(length(u_cam-a_position)*length(u_cam-a_position));
    gl_Position =  position;
}