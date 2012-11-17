attribute vec3 a_position; 
attribute vec2 a_texCoord0;
attribute vec3 a_normal;

uniform mat3 u_normal_matrix;
uniform vec4 u_cam_position;
uniform vec3 u_cam_direction;	
uniform mat4 u_pv;
uniform mat4 u_model_matrix;
uniform vec4 u_ambient;

#if LIGHTS_NUM > 0
uniform vec3 u_light_positions[LIGHTS_NUM];
uniform vec3 u_light_colours[LIGHTS_NUM];
uniform float u_light_intensities[LIGHTS_NUM];
#endif

#if DIR_LIGHTS > 0
uniform vec3 u_directional_light_direction[DIR_LIGHTS];
uniform vec3 u_directional_light_colour[DIR_LIGHTS];
#endif

#ifdef u_diffuse_colourFlag
uniform vec4 u_diffuse_colour;
#endif

#ifdef u_emissive_colourFlag
uniform vec4 u_emissive_colour;
#endif

#ifdef u_rim_colourFlag
uniform vec4 u_rim_colour;
#endif

#ifdef u_fog_colourFlag
varying float v_fog;
#endif

varying vec2 v_texCoords;
varying vec4 v_diffuse;

//wrap light. this is fastest light model
float wrapLight(vec3 nor, vec3 direction){
	return dot(nor, direction) * 0.5 + 0.5;
}

vec3 calculateLight(vec3 l_vector, vec3 l_colour, float l_attenuation, vec3 n_dir)
{
	if (length(l_colour) == 0) return vec3(0, 0, 0);

	float distance = length(l_vector);
	vec3 l_dir = normalize(l_vector);
	
	float attenuation = 1.0 / (l_attenuation * distance);
	float intensity = attenuation * max(0.0, dot(n_dir, l_dir));
	
	return l_colour * intensity;
}

void main()
{	
	v_texCoords = a_texCoord0;
	vec4 worldPos = u_model_matrix * vec4(a_position,1.0);
	gl_Position = u_pv * worldPos;

	vec3 pos  = worldPos.xyz;
	vec3 normal = normalize(u_normal_matrix * a_normal);
	
	vec3 light_agg_col = vec3(0, 0, 0);
	vec3 material_agg_col = vec3(0, 0, 0);

#if DIR_LIGHTS > 0
	for (int i = 0; i < DIR_LIGHTS; i++)
	{
		light_agg_col += u_direction_light_colour[i] * wrapLight(normal, -u_directional_light_direction[i]);
	}
#endif

#if LIGHTS_NUM > 0		
	for ( int i = 0; i < LIGHTS_NUM; i++ ){	
		//vec3 dif  = u_light_positions[i] - pos;
		//fastest way to calculate inverse of length				
		//float invLen = inversesqrt(dot(dif, dif));
		//float weight = invLen * u_light_intensities[i];
				
		//vec3 L = invLen * dif;// normalize
		//float lambert = wrapLight(normal, L);
		//weight *= lambert;		
		//light_agg_col += u_light_colours[i] * weight;

		vec3 light_model = u_light_positions[i] - pos;

		light_agg_col += calculateLight(light_model, u_light_colours[i], u_light_intensities[i], normal);
		
		
	}
#endif

#ifdef u_diffuse_colourFlag
	material_agg_col += u_diffuse_colour.rgb;
	#ifdef translucentFlag
		v_diffuse.a = u_diffuse_colour.a;	
	#endif
#else
	material_agg_col += vec3(1.0, 1.0, 1.0);
#endif

#ifdef u_emissive_colourFlag
	material_agg_col += u_emissive_colour.rgb;
#endif

#ifdef u_rim_colourFlag
	material_agg_col.rgb +=  pow( 1.0 - dot( normal, -u_cam_direction ), 2.0 ) * u_rim_colour.rgb;
#endif

#ifdef u_fog_colourFlag
	float fog  =  (distance(pos, u_cam_position.xyz) * u_cam_position.w);
	fog *=fog;	
	v_fog = min(fog, 1.0);	
#endif

	v_diffuse.rgb = material_agg_col * (u_ambient.rgb + light_agg_col);
	
}