attribute vec3 a_position; 
attribute vec2 a_texCoord0;
attribute vec3 a_normal;

uniform mat3 u_normal_matrix;
uniform mat4 u_pv;
uniform mat4 u_model_matrix;

uniform vec3 u_ambient_light;

#ifdef u_colourFlag
	uniform vec3 u_colour;
#endif

#if LIGHTS_NUM > 0
uniform vec3 u_light_positions[LIGHTS_NUM];
uniform vec3 u_light_colours[LIGHTS_NUM];
uniform float u_light_attenuations[LIGHTS_NUM];
uniform float u_light_intensities[LIGHTS_NUM];
#endif

varying vec2 v_texCoords;
varying vec3 v_diffuse;

// Diffuse light model. It actually works :p
vec3 calculateLight(vec3 l_vector, vec3 l_colour, float l_attenuation, float l_intensity, vec3 n_dir)
{
	if (length(l_colour) == 0) return vec3(0, 0, 0);

	float distance = length(l_vector);
	vec3 l_dir = normalize(l_vector);
	
	float attenuation = 1.0 / (l_attenuation * distance * distance);
	float intensity = attenuation * max(0.0, dot(n_dir, l_dir));
	
	return l_colour * intensity * l_intensity;
}

void main()
{	
	v_texCoords = a_texCoord0;
	vec4 worldPos = u_model_matrix * vec4(a_position,1.0);
	gl_Position = u_pv * worldPos;

	vec3 pos  = worldPos.xyz;
	vec3 normal = normalize(u_normal_matrix * a_normal);
	
	vec3 light = vec3(0, 0, 0);

	#if LIGHTS_NUM > 0		
		for ( int i = 0; i < LIGHTS_NUM; i++ ){	

			vec3 light_model = u_light_positions[i] - pos;

			light += calculateLight(light_model, u_light_colours[i], u_light_attenuations[i], u_light_intensities[i], normal);
		}
	#endif

	#ifdef u_colourFlag
		vec3 colour = u_colour;
	#else
		vec3 colour = vec3(1.0);
	#endif

	v_diffuse = colour * (u_ambient_light + light);
	
}