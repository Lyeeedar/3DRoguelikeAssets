attribute vec3 a_position;

uniform mat4 u_pv;
uniform vec3 u_model;

void main() 
{
	vec4 worldPos = vec4(a_position+u_model, 1.0);
	vec4 screenPos = u_pv * worldPos;
	gl_Position = screenPos;
}
