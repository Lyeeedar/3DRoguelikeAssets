uniform mat3 u_normal_matrix;

#ifdef u_normalmap_textureFlag
	uniform sampler2D u_normalmap_texture;
#endif

varying vec2 v_texCoords;
varying vec3 v_normal;
varying vec3 v_pos;
varying vec2 v_depth;

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
		vec3 normal = normalize((2.0 * texture2D(u_normalmap_texture, v_texCoords).xyz - 1.0) * computeTangentFrame(u_normal_matrix * v_normal, v_pos, v_texCoords));
	#else
		vec3 normal = normalize(u_normal_matrix * v_normal);
	#endif

	gl_FragColor.rgb = normal * 0.5 + 0.5;
	gl_FragColor.a = v_depth.x/v_depth.y;
}