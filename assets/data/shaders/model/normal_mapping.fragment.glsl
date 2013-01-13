
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

varying vec3 v_pos;

// Diffuse light model. It actually works :p
vec3 calculateLight(vec3 l_dir, vec3 l_colour, float l_attenuation, vec3 n_dir)
{
	if (length(l_colour) == 0) return vec3(0, 0, 0);
	
	float intensity = l_attenuation * max(0.0, dot(n_dir, l_dir));
	
	return l_colour * intensity;
}

mat3 compute_tangent_frame(vec3 normal, mat3 rot, vec2 UV)
{
	//mat3 tangent_space = mat3(0.0);

	//tangent_space[0] = normalize(u_model_matrix * vec4(UV.y, UV.x, 0.0, 0.0));
  	//tangent_space[2] = normalize(rot * normal);
  	//tangent_space[1] = normalize(cross(tangent_space[2], tangent_space[0]));

  	// compute derivations of the texture coordinate
	vec2 tc_dx = dFdx(UV);
	vec2 tc_dy = dFdy(UV);

	vec3 p_dx = dFdx(v_pos);
	vec3 p_dy = dFdy(v_pos);
	// compute initial tangent and bi-tangent
	vec3 t = normalize( tc_dy.y * p_dx - tc_dx.y * p_dy );
	vec3 b = normalize( tc_dy.x * p_dx - tc_dx.x * p_dy ); // sign inversion
	// get new tangent from a given mesh normal
	vec3 n = normalize(normal);
	vec3 x = cross(n, t);
	t = cross(x, n);
	t = normalize(t);
	// get updated bi-tangent
	x = cross(b, n);
	b = cross(n, x);
	b = normalize(b);
	return mat3(t, b, n);

	//return tangent_space;//mat3(normalize(T), normalize(B), Normal);
}

void main()
{		
	#ifdef u_normalmap_textureFlag
	vec3 normal = vec3(0.0);
	if (u_nm == 1)
		normal = normalize((2.0 * texture2D(u_normalmap_texture, v_texCoords).xyz - 1.0));// * compute_tangent_frame(v_normal, u_normal_matrix, v_texCoords));
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