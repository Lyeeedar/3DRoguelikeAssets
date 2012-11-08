varying vec4 v_colour;
varying vec2 v_texcoords;
varying float v_intensity;

uniform sampler2D texture;

void main(void) {
	gl_FragColor =  v_intensity * texture2D(texture, v_texcoords) * v_colour;
};