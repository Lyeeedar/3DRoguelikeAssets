attribute vec3 a_position;
attribute vec3 a_colour;
attribute vec2 a_texCoords;

uniform mat4 u_mv;

varying vec3 v_colour;
varying vec2 v_texCoords;

void main() {
    v_colour = a_colour;
    v_texCoords = a_texCoords;

    gl_Position = u_mv * vec4(a_position, 1.0);
}