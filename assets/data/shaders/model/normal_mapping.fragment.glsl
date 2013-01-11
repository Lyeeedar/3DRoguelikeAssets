
uniform mat3 u_normal_matrix;

#ifdef u_diffuse_textureFlag
	uniform sampler2D u_diffuse_texture;
#endif

#ifdef u_normalmap_textureFlag
	uniform sampler2D u_normalmap_texture;
#endif

#ifdef u_glowFlag
	uniform float u_glow;
#endif

#if LIGHTS_NUM > 0
	varying vec3 v_light_direction[LIGHTS_NUM];
	varying float v_light_attenuation[LIGHTS_NUM];
	varying vec3 v_light_colour[LIGHTS_NUM];
#endif

varying vec2 v_texCoords;
varying vec3 v_normal;

varying vec3 v_colour;
varying vec3 v_baked_light;

// Diffuse light model. It actually works :p
vec3 calculateLight(vec3 l_dir, vec3 l_colour, float l_attenuation, vec3 n_dir)
{
	if (length(l_colour) == 0) return vec3(0, 0, 0);
	
	float intensity = l_attenuation * max(0.0, dot(n_dir, l_dir));
	
	return l_colour * intensity;
}

void main()
{		
	#ifdef u_normalmap_textureFlag
		vec3 normal = texture2D(u_normalmap_texture, v_texCoords) * normalize(u_normal_matrix * v_normal);
	#else
		vec3 normal = normalize(u_normal_matrix * v_normal);
	#endif

	vec3 light = vec3(0.0);

	#if LIGHTS_NUM > 0		
		for ( int i = 0; i < LIGHTS_NUM; i++ ){	
			light += calculateLight(v_light_direction[i], v_light_colour[i], v_light_attenuation[i], normal);
		}
	#endif

	#if LIGHTS_NUM > 0
		vec3 diffuse = v_colour * (v_baked_light + light);
	#else
		vec3 diffuse = v_colour * v_baked_light;
	#endif
	
	#ifdef u_diffuse_textureFlag
		diffuse *= texture2D(u_diffuse_texture, v_texCoords);
	#endif

	gl_FragColor.rgb = diffuse.rgb;

	#ifdef u_glowFlag
		gl_FragColor.a = u_glow;
	#else
		gl_FragColor.a = 0.0;
	#endif

}