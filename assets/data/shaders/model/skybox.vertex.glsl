attribute vec3 a_position;

uniform mat4 u_pv;
uniform vec3 u_pos;

varying vec3 v_texCoords;

void main() {
    v_texCoords = a_position;
    gl_Position = u_pv * vec4(a_position+u_pos, 1.0);
}