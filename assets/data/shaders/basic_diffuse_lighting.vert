attribute vec3 a_position;
attribute vec3 a_normal;
attribute vec2 a_texCoord0;

uniform mat4 u_mvp;
uniform mat4 u_model;
uniform mat3 u_normal;
uniform vec3 u_colour;
uniform vec3 u_ambient;

const int max_lights = 5;

uniform vec3 u_light_vector[max_lights];
uniform vec3 u_light_colour[max_lights];
uniform float u_light_attenuation[max_lights];

varying vec2 v_texcoords;
varying vec4 v_colour;

vec3 calculateLight(vec3 l_vector, vec3 l_colour, vec3 l_attenuation, vec3 n_dir)
{
	if (length(l_colour) == 0) return vec3(0, 0, 0);

	float distance = length(l_vector);
	vec3 l_dir = normalize(l_vector);
	
	float attenuation = 1.0 / (l_attenuation * distance);
	float intensity = attenuation * max(0.0, dot(n_dir, l_dir));
	
	return l_colour * intensity;
}

void main(void) {
	gl_Position = u_mvp * vec4(a_position, 1.0);
	v_texcoords = a_texCoord0;
	
	vec3 normalDirection = normalize(u_normal * a_normal);
	vec3 colour = vec3(0, 0, 0);
	
	vec3 vertex_position = (u_model * vec4(a_position, 1.0));
	
	for (int i = 0; i < max_lights; i++)
	{
		vec3 light_model = u_light_vector[i] - vertex_position;

		colour += calculateLight(light_model, u_light_colour[i], u_light_attenuation[i], normalDirection);
	}

	v_colour = vec4(u_colour, 1.0) * (
	vec4(u_ambient, 1.0) +
	vec4(colour, 1.0)
	);
};