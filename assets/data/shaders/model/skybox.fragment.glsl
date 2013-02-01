
uniform samplerCube u_texture;

varying vec3 v_texCoords;

 void main() {
    vec4 cube = textureCube(u_texture, v_texCoords);
    gl_FragColor = cube;
 }