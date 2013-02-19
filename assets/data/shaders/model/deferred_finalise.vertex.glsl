attribute vec3 a_position; 
attribute vec2 a_texCoord0;

uniform mat4 u_pv;
uniform mat4 u_model_matrix;

varying vec2 v_texCoords;

void main()
{	
	v_texCoords = a_texCoord0;

	vec4 worldPos = u_model_matrix * vec4(a_position,1.0);
	vec4 screenPos = u_pv * worldPos;
	gl_Position = screenPos;
}