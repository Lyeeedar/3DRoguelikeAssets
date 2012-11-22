#ifdef GL_ES
#define LOWP lowp
#define MED mediump
precision lowp float;
#else
#define MED
#define LOWP
#endif

#ifdef u_diffuse_textureFlag
uniform sampler2D u_diffuse_texture;
#endif

#ifdef u_lightmap_textureFlag
uniform sampler2D u_lightmap_texture;
#endif

#ifdef u_fog_colourFlag
uniform vec4 u_fog_colour;
varying float v_fog;
#endif

#ifdef u_glowFlag
uniform float u_glow;
#endif

varying MED vec2 v_texCoords;
varying vec4 v_diffuse;
void main()
{		
	vec4 light = v_diffuse;
	
#ifdef u_lightmap_textureFlag
	light *= texture2D(u_lightmap_texture, v_texCoords);
#endif
	
#ifdef u_diffuse_textureFlag
	light *= texture2D(u_diffuse_texture, v_texCoords);
#endif
	
#ifdef u_fog_colourFlag
	light.rgb = mix(light.rgb, u_fog_colour.rgb, v_fog);		
		#ifdef u_translucentFlag
			light.a += v_fog;
		#endif
#endif
	

	gl_FragColor.rgb = light.rgb;

#ifdef u_glowFlag
	gl_FragColor.a = u_glow;
#else
	gl_FragColor.a = 0.0;
#endif

}