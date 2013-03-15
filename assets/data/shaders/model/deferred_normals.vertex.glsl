

attribute vec3 a_position; 
attribute vec2 a_texCoord0;
attribute vec3 a_normal;

uniform mat4 u_pv;
uniform mat4 u_model_matrix;
uniform mat3 u_normal_matrix;
uniform vec3 u_cam;

uniform mat4 u_v;

varying vec2 v_texCoords;
varying vec3 v_normal;
varying vec3 v_pos;
//varying vec2 v_depth;

varying vec3 v_d;

void main()
{	
	v_normal = a_normal;
	v_texCoords = a_texCoord0;

	vec4 worldPos = u_model_matrix * vec4(a_position,1.0);
	vec4 screenPos = u_pv * worldPos;
	gl_Position = screenPos;

	//v_depth.xy = screenPos.zw; 
	v_pos = worldPos.xyz;

	v_d = (u_v * worldPos).xyz;
}