attribute vec3 a_position; 
attribute vec2 a_texCoord0;
attribute vec3 a_normal;
attribute vec3 a_colour;
attribute vec3 a_baked_light;
attribute vec4 a_tangent;

#if LIGHTS_NUM > 0
	uniform vec3 u_light_positions[LIGHTS_NUM];
	uniform vec3 u_light_colours[LIGHTS_NUM];
	uniform float u_light_attenuations[LIGHTS_NUM];
	uniform float u_light_intensities[LIGHTS_NUM];

	varying vec3 v_light_direction[LIGHTS_NUM];
	varying float v_light_attenuation[LIGHTS_NUM];
	varying vec3 v_light_colour[LIGHTS_NUM];
#endif

uniform mat4 u_pv;
uniform mat4 u_model_matrix;
uniform mat3 u_normal_matrix;

varying vec2 v_texCoords;
varying vec3 v_normal;

varying vec3 v_colour;
varying vec3 v_baked_light;

varying mat3 v_tangent_space;
varying vec3 v_pos;

// Diffuse light model. It actually works :p
void calculateLightVariables(int index, vec3 l_vector, vec3 l_colour, float l_attenuation, float l_intensity)
{
	float distance = length(l_vector);
	vec3 l_dir = normalize(l_vector);
	
	float attenuation = 1.0 / (l_attenuation * distance * distance);

	v_light_direction[index] = l_dir;
	v_light_attenuation[index] = attenuation;
	v_light_colour[index] = l_colour * l_intensity;
}

void main()
{	
	v_normal = a_normal;
	v_texCoords = a_texCoord0;

	vec4 worldPos = u_model_matrix * vec4(a_position,1.0);
	gl_Position = u_pv * worldPos;

	v_pos = worldPos.xyz;

	#if LIGHTS_NUM > 0		
		for ( int i = 0; i < LIGHTS_NUM; i++ ){	
			vec3 light_model = u_light_positions[i] - worldPos.xyz;
			calculateLightVariables(i, light_model, u_light_colours[i], u_light_attenuations[i], u_light_intensities[i]);
		}
	#endif

	v_colour = a_colour;
	v_baked_light = a_baked_light;


	vec3 binormal = cross(a_normal, a_tangent.xyz);

	v_tangent_space = mat3(
		normalize(u_normal_matrix * a_tangent.xyz),
		normalize(u_normal_matrix * binormal),
		normalize(u_normal_matrix * a_normal));
}