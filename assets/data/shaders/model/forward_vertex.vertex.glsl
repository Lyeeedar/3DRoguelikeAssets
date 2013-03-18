
attribute vec3 a_position; 
attribute vec2 a_texCoord0;
attribute vec3 a_normal;
attribute vec3 a_baked_light;

uniform mat4 u_pv;
uniform mat4 u_model_matrix;
uniform vec3 u_colour;

#if LIGHTS_NUM > 0
uniform mat3 u_normal_matrix;
uniform vec3 u_light_positions[LIGHTS_NUM];
uniform vec3 u_light_colours[LIGHTS_NUM];
uniform float u_light_attenuations[LIGHTS_NUM];
uniform float u_light_powers[LIGHTS_NUM];
#endif

varying vec2 v_texCoords;
varying vec3 v_diffuse;

#if LIGHTS_NUM > 0
vec3 calculateLight(vec3 l_vector, vec3 l_colour, float l_attenuation, float l_power, vec3 n_dir)
{
    float distance = length(l_vector);
    vec3 l_dir = l_vector / distance;
 
    //Intensity of the diffuse light. Saturate to keep within the 0-1 range.
    float NdotL = dot( n_dir, l_dir );
    float intensity = clamp( NdotL, 0.0, 1.0 );
    float attenuation = 1.0 / ( l_attenuation*distance + l_attenuation / 10.0 * distance * distance );
 
    // Calculate the diffuse light factoring in light color, power and the attenuation
   	return l_colour * intensity * l_power * attenuation;
}
#endif

void main()
{	
	v_texCoords = a_texCoord0;
	vec4 worldPos = u_model_matrix * vec4(a_position,1.0);
	gl_Position = u_pv * worldPos;

	#if LIGHTS_NUM > 0	
		vec3 light = vec3(0.0);
		vec3 normal = normalize(u_normal_matrix * a_normal);
		vec3 pos = worldPos.xyz;
		
		for ( int i = 0; i < LIGHTS_NUM; i++ ){	

			vec3 light_model = u_light_positions[i] - pos;

			light += calculateLight(light_model, u_light_colours[i], u_light_attenuations[i], u_light_powers[i], normal);
		}
	#endif

	vec3 colour = u_colour;


	#if LIGHTS_NUM > 0
		v_diffuse = colour * (a_baked_light + light);
	#else
		v_diffuse = colour * (a_baked_light);
	#endif
	
}