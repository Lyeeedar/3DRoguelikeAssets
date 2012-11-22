attribute vec3 a_position;
attribute vec2 a_texCoord0;

uniform mat4 u_mvp;

varying vec2 v_texcoords;

void main(void) {
	gl_Position = u_mvp * vec4(a_position, 1.0);
	v_texcoords = a_texCoord0;
};