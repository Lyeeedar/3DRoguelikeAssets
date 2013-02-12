attribute vec3 a_position; 
attribute vec2 a_texCoord0;
attribute vec3 a_normal;

uniform mat4 u_pv;
uniform mat4 u_model_matrix;
uniform mat3 u_normal_matrix;

uniform vec3 u_ambient_light;

#ifdef u_colourFlag
	uniform vec3 u_colour;
#endif

varying vec2 v_texCoords;
varying vec3 v_normal;

varying vec3 v_colour;

varying vec3 v_pos;

varying vec3 v_ambient_light;

void main()
{	
	v_normal = a_normal;
	v_texCoords = a_texCoord0;

	vec4 worldPos = u_model_matrix * vec4(a_position,1.0);
	gl_Position = u_pv * worldPos;

	v_pos = worldPos.xyz;

	#ifdef u_colourFlag
		v_colour = u_colour;
	#else
		v_colour = vec3(1.0);
	#endif

	v_ambient_light = u_ambient_light;
}