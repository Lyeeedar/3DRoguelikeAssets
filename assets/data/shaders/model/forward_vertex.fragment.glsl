uniform sampler2D u_diffuse_texture;

varying vec2 v_texCoords;
varying vec3 v_diffuse;
void main()
{		
	vec3 light = v_diffuse * texture2D(u_diffuse_texture, v_texCoords).rgb;

	gl_FragColor.rgb = light;

	gl_FragColor.a = 1.0;

}