
attribute vec3 a_position; 
attribute vec2 a_texCoord0;
attribute vec3 a_normal;
attribute vec3 a_baked_light;

uniform mat4 u_pv;
uniform mat4 u_model_matrix;
uniform mat3 u_normal_matrix;

varying vec2 v_texCoords;
varying vec3 v_diffuse;
varying vec3 v_pos;
varying vec3 v_normal;

void main()
{	
	v_texCoords = a_texCoord0;
	vec4 worldPos = u_model_matrix * vec4(a_position,1.0);
	gl_Position = u_pv * worldPos;

	v_pos = worldPos.xyz;
	v_normal = normalize(u_normal_matrix * a_normal);

	v_diffuse = a_baked_light;
	
}