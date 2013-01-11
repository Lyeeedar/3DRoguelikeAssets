
varying float v_texCoord;
varying vec4 v_colour;

uniform sampler2D u_texture;

void main(void) {
	gl_FragColor = texture2D(u_texture, vec2(0, v_texCoord)) * v_colour;
};