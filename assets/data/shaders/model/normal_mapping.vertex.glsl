attribute vec3 a_position; 
attribute vec2 a_texCoord0;
attribute vec3 a_normal;
attribute vec3 a_colour;
attribute vec3 a_baked_light;

uniform mat4 u_pv;
uniform mat4 u_model_matrix;
uniform mat3 u_normal_matrix;

varying vec2 v_texCoords;
varying vec3 v_normal;

varying vec3 v_colour;
varying vec3 v_baked_light;

varying vec3 v_pos;

void main()
{	
	v_normal = a_normal;
	v_texCoords = a_texCoord0;

	vec4 worldPos = u_model_matrix * vec4(a_position,1.0);
	gl_Position = u_pv * worldPos;

	v_pos = worldPos.xyz;

	v_colour = a_colour;
	v_baked_light = a_baked_light;
}