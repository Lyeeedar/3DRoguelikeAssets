#ifdef GL_ES
  precision highp float;
#endif

uniform sampler2D u_normals;

uniform vec3 u_colour;
uniform float u_attenuation;
uniform float u_power;
//uniform mat4 u_inv_pv;
uniform vec3 u_model;
uniform vec3 u_cam;

uniform mat4 u_inv_v;

uniform vec2 u_screen;

uniform float u_linearDepth;

varying vec3 v_pos;

vec3 calculateLight(vec3 l_vector, vec3 l_colour, float l_attenuation, float l_power, vec3 n_dir, vec3 v_dir)
{
    float distance = length( l_vector );
    vec3 l_dir = l_vector / distance;

    float NdotL = dot( n_dir, l_dir );
    float intensity = clamp( NdotL, 0.0, 1.0 );
    float attenuation = 1.0 / ( l_attenuation*distance + l_attenuation / 10.0 * distance * distance );
 
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

float unpackHalf (vec2 colour)
{
	return colour.x + (colour.y / 255.0);
}

vec3 decode(vec2 enc)
{
	vec2 fenc = enc*4.0-2.0;
    float f = dot(fenc,fenc);
    float g = sqrt(1.0-f/4.0);
    vec3 n;
    n.xy = fenc*g;
    n.z = 1.0-f/2.0;
    return n;
}

void main() 
{
	vec2 screenPos = ( gl_FragCoord.xy ) / u_screen;
	vec4 storedData = texture2D( u_normals, screenPos );

	float depth = unpackHalf( storedData.ba );
	vec3 normal = normalize( ( u_inv_v * vec4(decode(storedData.rg), 0.0) ).xyz);

	vec3 viewRay = normalize( v_pos - u_cam );

	vec3 pixelPos = u_cam + viewRay * ( depth * u_linearDepth );

	vec3 l_vector = u_model - pixelPos;
	vec3 viewDir = u_cam - pixelPos;

	vec3 light = calculateLight( l_vector, u_colour, u_attenuation, u_power, normal, viewDir );

	gl_FragColor.rgb = light.rgb / 5.0;
}