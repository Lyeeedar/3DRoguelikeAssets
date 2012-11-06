varying vec4 v_colour;
varying vec2 v_texcoords;

uniform sampler2D texture;

void main(void) {
	gl_FragColor =  v_colour * texture2D(texture, v_texcoords);
};