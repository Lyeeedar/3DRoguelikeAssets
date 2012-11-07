attribute vec3 a_position;
attribute vec2 a_texcoords;

uniform mat4 u_mvp;
uniform vec3 u_position;
uniform vec3 u_colour;
uniform vec3 u_ambient;

uniform vec3 u_light1_position;
uniform vec3 u_light1_colour;
uniform float u_light1_attenuation;

uniform vec3 u_light2_position;
uniform vec3 u_light2_colour;
uniform float u_light2_attenuation;

uniform vec3 u_light3_position;
uniform vec3 u_light3_colour;
uniform float u_light3_attenuation;

uniform vec3 u_light4_position;
uniform vec3 u_light4_colour;
uniform float u_light4_attenuation;

varying vec2 v_texcoords;
varying vec4 v_colour;

void main(void) {
	gl_Position = u_mvp * vec4(a_position, 1.0);
	v_texcoords = a_texcoords;
	
	float brightness1 = 1 - length ( u_position + a_position - u_light1_position ) / u_light1_attenuation;
	float brightness2 = 1 - length ( u_position + a_position - u_light2_position ) / u_light2_attenuation;
	float brightness3 = 1 - length ( u_position + a_position - u_light3_position ) / u_light3_attenuation;
	float brightness4 = 1 - length ( u_position + a_position - u_light4_position ) / u_light4_attenuation;
	
	v_colour = vec4(u_colour, 1.0) * (
	vec4(u_ambient, 1.0) +
	vec4((u_light1_colour * brightness1), 1.0) + 
	vec4((u_light2_colour * brightness2), 1.0) + 
	vec4((u_light3_colour * brightness3), 1.0) +
	vec4((u_light4_colour * brightness4), 1.0)
	);
};