
varying vec2 v_texcoords;

uniform sampler2D texture;

void main(void) {
	gl_FragColor =  texture2D(texture, v_texcoords) + vec4(1.0, 1.0, 1.0, 1.0);
};