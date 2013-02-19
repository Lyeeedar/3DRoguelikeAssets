
uniform sampler2D u_normals;

uniform vec3 u_colour;
uniform float u_attenuation;
uniform float u_power;
uniform mat4 u_inv_pv;
uniform vec3 u_model;

uniform vec2 u_screen;

vec3 calculateLight(vec3 l_vector, vec3 l_colour, float l_attenuation, float l_power, vec3 n_dir)
{
    float distance = length(l_vector);
    vec3 l_dir = l_vector / distance;

    float NdotL = dot( n_dir, l_dir );
    float intensity = clamp( NdotL, 0.0, 1.0 );
 
   	return l_colour * intensity * l_power / (l_attenuation*distance + l_attenuation/5*distance*distance);
}

void main() 
{
	vec2 screenPos = (gl_FragCoord.xy)/u_screen;
	vec4 storedData = texture2D(u_normals, screenPos);

	float depth = storedData.a;
	vec3 normal = normalize((storedData.rgb * 2) - 1);

	vec4 pixelPos;
	pixelPos.xy = screenPos * 2 - 1;
	pixelPos.z = depth;
	pixelPos.w = 1.0;

	pixelPos = u_inv_pv * pixelPos;
	pixelPos.xyz /= pixelPos.w;

	vec3 l_vector = u_model - pixelPos.xyz;

	vec3 light = calculateLight(l_vector, u_colour, u_attenuation, u_power, normal);

	gl_FragColor.rgb = light.rgb / 5;
}