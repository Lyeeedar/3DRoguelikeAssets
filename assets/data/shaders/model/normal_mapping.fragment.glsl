
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
	uniform vec3 u_light_positions[LIGHTS_NUM];
	uniform vec3 u_light_colours[LIGHTS_NUM];
	uniform float u_light_attenuations[LIGHTS_NUM];
	uniform float u_light_intensities[LIGHTS_NUM];
#endif

varying vec2 v_texCoords;
varying vec3 v_normal;

varying vec3 v_colour;

varying vec3 v_ambient_light;

varying vec3 v_pos;

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

mat3 computeTangentFrame(vec3 normal, vec3 position, vec2 texCoord)
{
    vec3 dpx = dFdx(position);
    vec3 dpy = dFdy(position);
    vec2 dtx = dFdx(texCoord);
    vec2 dty = dFdy(texCoord);
    
    vec3 tangent = normalize(dpx * dty.t - dpy * dtx.t);
	vec3 binormal = normalize(-dpx * dty.s + dpy * dtx.s);
   
    return mat3(tangent, binormal, normal);
}

void main()
{		
	#ifdef u_normalmap_textureFlag
		vec3 normal = normalize((2.0 * texture2D(u_normalmap_texture, v_texCoords).xyz - 1.0) * computeTangentFrame(v_normal, v_pos, v_texCoords));
	#else
		vec3 normal = normalize(u_normal_matrix * v_normal);
	#endif

	vec3 light = vec3(0.0);

	#if LIGHTS_NUM > 0		
		for ( int i = 0; i < LIGHTS_NUM; i++ ){	

			vec3 light_model = u_light_positions[i] - v_pos;

			light += calculateLight(light_model, u_light_colours[i], u_light_attenuations[i], u_light_intensities[i], normal);
		}
	#endif

	vec3 diffuse = v_colour * (v_ambient_light + light);
	
	#ifdef u_diffuse_textureFlag
		diffuse *= texture2D(u_diffuse_texture, v_texCoords);
	#endif

	gl_FragColor.rgb = diffuse.rgb;

	gl_FragColor.a = 1.0;

}