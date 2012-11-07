attribute vec3 a_position;
attribute vec3 a_normal;
attribute vec2 a_texcoords;

uniform mat4 u_mvp;
uniform mat4 u_position;
uniform vec3 u_colour;

uniform vec3 u_light_position;
uniform vec3 u_light_colour;

varying vec2 v_texcoords;
varying vec4 v_colour;

void main(void) {
	gl_Position = u_mvp * vec4(a_position, 1.0);
	v_texcoords = a_texcoords;

	vec3 normalDirection = normalize(vec3(u_position * vec4(a_normal, 0.0)));
  	vec3 lightDirection = u_position * vec4(normalize(u_light_position), 1.0);
 
  	vec3 diffuseReflection
    = vec3(u_light_colour) * max(0.0, dot(normalDirection, lightDirection));
	
	v_colour = vec4(u_colour, 1.0) * vec4(diffuseReflection, 1.0);
};