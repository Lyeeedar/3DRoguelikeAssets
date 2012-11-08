attribute vec3 a_position;
attribute vec3 a_normal;
attribute vec2 a_texcoords;

uniform mat4 u_mvp;
uniform mat4 u_model;
uniform mat3 u_normal;
uniform vec3 u_colour;

uniform vec3 u_light_position;
uniform vec3 u_light_colour;

varying vec2 v_texcoords;
varying vec4 v_colour;
varying float v_intensity;

void main(void) {
	gl_Position = u_mvp * vec4(a_position, 1.0);
	v_texcoords = a_texcoords;

	vec3 normalDirection = normalize(u_normal * a_normal);
	
	vec3 vertexToLightSource = vec3(u_light_position - u_model * vec4(a_position, 1.0));
    float distance = length(vertexToLightSource);
    float attenuation = 1.0 / ( 0.2 * distance );
    vec3 lightDirection = normalize(vertexToLightSource);
  	//vec3 lightDirection = normalize(u_light_position);
	
	v_intensity = attenuation * max(dot(normalDirection, lightDirection), 0.0);
	v_colour = vec4(u_colour * u_light_colour, 1.0);
};