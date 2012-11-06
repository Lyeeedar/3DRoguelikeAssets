varying vec4 v_colour;
varying vec2 v_texcoords;
varying float v_brightness;

uniform sampler2D texture;

void main(void) {
	gl_FragColor =  texture2D(texture, v_texcoords) * vec4(v_brightness, v_brightness, v_brightness, 1.0) * v_colour;
};