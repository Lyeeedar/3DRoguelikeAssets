uniform sampler2D u_diffuse_texture;

varying vec2 v_texCoords;
varying vec3 v_normal;

void main()
{		
	vec4 light = vec4(1.0);

	gl_FragColor.rgb = texture2D(u_diffuse_texture, v_texCoords) * light.rgb;

	gl_FragColor.a = 1.0;
}