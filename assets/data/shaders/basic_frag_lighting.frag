varying vec4 v_colour;
varying vec2 v_texcoords;
varying vec3 v_position;
varying float brightness;

uniform sampler2D texture;

void main(void) {
	float brightness = 1 - length ( v_position ) / 100; 
	gl_FragColor =  texture2D(texture, v_texcoords) * vec4(brightness, brightness, brightness, 1.0) * v_colour;
};