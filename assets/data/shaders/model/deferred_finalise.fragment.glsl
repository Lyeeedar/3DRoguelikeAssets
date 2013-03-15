#ifdef GL_ES
	precision mediump float;
#endif

uniform sampler2D u_diffuse_texture;

uniform sampler2D u_light_texture;

uniform vec2 u_screen;
uniform vec3 u_colour;

varying vec2 v_texCoords;

void main()
{
	vec2 lTexCoords = gl_FragCoord.xy/u_screen;
	vec3 light = texture2D(u_light_texture, lTexCoords).rgb * 5.0;
	vec3 diffuse = u_colour * light;
	
	diffuse *= texture2D(u_diffuse_texture, v_texCoords).rgb;

	gl_FragColor.rgb = diffuse.rgb;
	gl_FragColor.a = 1.0;

}