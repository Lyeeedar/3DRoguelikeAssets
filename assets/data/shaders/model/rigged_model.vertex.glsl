attribute vec3 a_position; 
attribute vec2 a_texCoord0;
attribute vec3 a_normal;

uniform mat4 u_pv;
uniform mat4 u_model_matrix;

varying vec2 v_texCoords;
varying vec3 v_normal;

void main()
{	
	v_normal = a_normal;
	v_texCoords = a_texCoord0;

	vec4 worldPos = u_model_matrix * vec4(a_position,1.0);
	gl_Position = u_pv * worldPos;
}