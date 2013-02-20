
uniform sampler2D u_normals;

uniform vec3 u_colour;
uniform float u_attenuation;
uniform float u_power;
uniform mat4 u_inv_pv;
uniform vec3 u_model;
uniform vec3 u_cam;

uniform vec2 u_screen;

vec3 calculateLight(vec3 l_vector, vec3 l_colour, float l_attenuation, float l_power, vec3 n_dir, vec3 v_dir)
{
    float distance = length( l_vector );
    vec3 l_dir = l_vector / distance;

    float NdotL = dot( n_dir, l_dir );
    float intensity = clamp( NdotL, 0.0, 1.0 );
    float attenuation = 1 / ( l_attenuation*distance + l_attenuation / 5 * distance * distance );
 
   	vec3 diffuse = l_colour * intensity * l_power * attenuation;

   	vec3 specular;
	if ( NdotL < 0.0)
    {
      specular = vec3(0.0, 0.0, 0.0);
    }
 	else
    {
      specular = attenuation / ( l_attenuation*distance*distance ) * l_colour * pow( max( 0.0, dot( reflect( -l_dir, n_dir), v_dir ) ), 1.0);
    }

   	return diffuse;// + specular;
}

void main() 
{
	vec2 screenPos = ( gl_FragCoord.xy ) / u_screen;
	vec4 storedData = texture2D( u_normals, screenPos );

	float depth = storedData.a;
	vec3 normal = normalize( ( storedData.rgb * 2 ) - 1 );

	vec4 pixelPos;
	pixelPos.xy = screenPos * 2 - 1;
	pixelPos.z = depth;
	pixelPos.w = 1.0;

	pixelPos = u_inv_pv * pixelPos;
	pixelPos.xyz /= pixelPos.w;

	vec3 l_vector = u_model - pixelPos.xyz;
	vec3 viewDir = u_cam - pixelPos.xyz;

	vec3 light = calculateLight( l_vector, u_colour, u_attenuation, u_power, normal, viewDir );

	gl_FragColor.rgb = light.rgb / 5;
}