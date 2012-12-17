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

#ifdef u_glowFlag
uniform float u_glow;
#endif

varying MED vec2 v_texCoords;
varying vec4 v_diffuse;
void main()
{		
	vec4 light = v_diffuse;
	
#ifdef u_diffuse_textureFlag
	light *= texture2D(u_diffuse_texture, v_texCoords);
#endif

	gl_FragColor.rgb = light.rgb;

#ifdef u_glowFlag
	gl_FragColor.a = u_glow;
#else
	gl_FragColor.a = 0.0;
#endif

}