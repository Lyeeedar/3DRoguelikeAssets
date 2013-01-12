
uniform mat3 u_normal_matrix;
uniform int u_nm;

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

varying mat3 v_tangent_space;

// Diffuse light model. It actually works :p
vec3 calculateLight(vec3 l_dir, vec3 l_colour, float l_attenuation, vec3 n_dir)
{
	if (length(l_colour) == 0) return vec3(0, 0, 0);
	
	float intensity = l_attenuation * max(0.0, dot(n_dir, l_dir));
	
	return l_colour * intensity;
}

mat3 compute_tangent_frame(vec3 Normal, vec3 View, vec2 UV)
{
	vec3 dp1 = dFdx(View);
	vec3 dp2 = dFdy(View);
	vec2 duv1 = dFdx(UV);
	vec2 duv2 = dFdy(UV);

	mat3 M = mat3(dp1, dp2, cross(dp1, dp2));
	mat3 inverseM = mat3( cross( M[1], M[2] ), cross( M[2], M[0] ), vec3(0.0) );
	vec3 T = vec3(duv1.x, duv2.x, 0.0)*inverseM;
	vec3 B = vec3(duv1.y, duv2.y, 0.0)*inverseM;

	return mat3(normalize(T), normalize(B), Normal);
}

void main()
{		
	#ifdef u_normalmap_textureFlag
	vec3 normal = vec3(0.0);
	if (u_nm == 1)
		normal = normalize((2.0 * texture2D(u_normalmap_texture, v_texCoords).xyz - 1.0));
			//* compute_tangent_frame(v_normal, u_normal_matrix*v_normal, v_texCoords));
	else
		normal = normalize(u_normal_matrix * v_normal);
		//vec3 normal = texture2D(u_normalmap_texture, v_texCoords);//normalize((2.0 * texture2D(u_normalmap_texture, v_texCoords).xyz - 1.0) 
			//* compute_tangent_frame(v_normal, u_normal_matrix*v_normal, v_texCoords));
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