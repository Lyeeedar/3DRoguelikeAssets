attribute vec3 a_position;
attribute vec3 a_colour;

uniform mat4 u_mv;
uniform vec3 u_cam;

varying vec3 v_colour;

void main() {
    vec4 position = u_mv * vec4(a_position, 1.0);
    v_colour = a_colour;
    float dist = distance(a_position, u_cam);
    //gl_PointSize = max(100/dist*dist, 10);
    gl_Position = position;

	float att = sqrt(1.0 / (0.0 +
                        (1.0 +
                        0.0 * dist) * dist));
	float size = clamp(10.0 * att, 5.0, 256.0);
	gl_PointSize = size;
}