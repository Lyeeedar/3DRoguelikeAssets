#ifdef GL_ES
    precision mediump float;
#endif

varying vec4 v_color;
varying vec2 v_texCoords;
uniform sampler2D u_texture;

uniform mat4 u_inv_v;

vec3 decode(vec2 enc)
{
	vec2 fenc = enc*4-2;
    float f = dot(fenc,fenc);
    float g = sqrt(1-f/4);
    vec3 n;
    n.xy = fenc*g;
    n.z = 1-f/2;
    return n;
}

void main() {
	vec4 colour = texture2D(u_texture, v_texCoords);

	vec3 normal = normalize( ( ( ( u_inv_v * vec4(decode(colour.rg), 0.0) ).xyz ) * 0.5 ) +0.5 );

    gl_FragColor.rgb = normal;
    gl_FragColor.a = 1.0;
}