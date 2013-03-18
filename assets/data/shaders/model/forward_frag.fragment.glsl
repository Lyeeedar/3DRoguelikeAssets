#ifdef GL_ES
	precision mediump float;
#endif

#if LIGHTS_NUM > 0
	uniform vec3 u_light_positions[LIGHTS_NUM];
	uniform vec3 u_light_colours[LIGHTS_NUM];
	uniform float u_light_attenuations[LIGHTS_NUM];
	uniform float u_light_powers[LIGHTS_NUM];
#endif

uniform sampler2D u_diffuse_texture;
uniform vec3 u_colour;

varying vec2 v_texCoords;
varying vec3 v_diffuse;
varying vec3 v_pos;
varying vec3 v_normal;

#if LIGHTS_NUM > 0
	vec3 calculateLight(vec3 l_vector, vec3 l_colour, float l_attenuation, float l_power, vec3 n_dir)
	{
	    float distance = length(l_vector);
	    vec3 l_dir = l_vector / distance;

	    float NdotL = dot( n_dir, l_dir );
	    float intensity = clamp( NdotL, 0.0, 1.0 );
	    float attenuation = 1.0 / ( l_attenuation*distance + l_attenuation / 10.0 * distance * distance );
	 
	   	return l_colour * intensity * l_power * attenuation;
	}
#endif

void main()
{	
	vec3 light = vec3(0, 0, 0);
	#if LIGHTS_NUM > 0
		for ( int i = 0; i < LIGHTS_NUM; i++ ) {

			vec3 light_model = u_light_positions[i] - v_pos;

			light += calculateLight(light_model, u_light_colours[i], u_light_attenuations[i], u_light_powers[i], v_normal);
		}
	#endif

	gl_FragColor.rgb = u_colour * texture2D(u_diffuse_texture, v_texCoords).rgb * (v_diffuse+light);

	gl_FragColor.a = 1.0;

}