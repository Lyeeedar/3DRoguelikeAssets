attribute vec3 a_position;
attribute vec3 a_normal;
attribute vec2 a_texCoord0;

uniform mat4 u_mvp;
uniform mat4 u_model;
uniform mat3 u_normal;
uniform vec3 u_colour;
uniform vec3 u_ambient;

uniform vec3 u_light1_position;
uniform vec3 u_light1_colour;
uniform float u_light1_attenuation;

varying vec2 v_texcoords;
varying vec4 v_colour;

void main(void) {
	gl_Position = u_mvp * vec4(a_position, 1.0);
	v_texcoords = a_texCoord0;

	vec3 normalDirection = normalize(u_normal * a_normal);
	
	vec3 light1ToModel = u_light1_position - (u_model * vec4(a_position, 1.0));
	
    float distance = length(light1ToModel);
    float attenuation = 1.0 / ( u_light1_attenuation * distance );
    vec3 lightDirection = normalize(light1ToModel);
	
	float intensity = attenuation * max(0.0, dot(normalDirection, lightDirection));
	v_colour = vec4(u_colour, 1.0) * (
	vec4(u_ambient, 1.0) +
	vec4(u_light1_colour * intensity, 1.0)
	);
};