#ifdef GL_ES
    precision mediump float;
#endif

varying vec4 v_color;
varying vec2 v_texCoords;
uniform sampler2D u_texture;

const float blurSize = 1.0/512.0;

void main() {

	vec4 sum = vec4(0.0);
 
   //sum += texture2D(u_texture, vec2(v_texCoords.x - 4.0*blurSize, v_texCoords.y)) * 0.05;
   //sum += texture2D(u_texture, vec2(v_texCoords.x - 3.0*blurSize, v_texCoords.y)) * 0.09;
   //sum += texture2D(u_texture, vec2(v_texCoords.x - 2.0*blurSize, v_texCoords.y)) * 0.12;
   //sum += texture2D(u_texture, vec2(v_texCoords.x - blurSize, v_texCoords.y)) * 0.15;
   //sum += texture2D(u_texture, vec2(v_texCoords.x, v_texCoords.y)) * 0.16;
   //sum += texture2D(u_texture, vec2(v_texCoords.x + blurSize, v_texCoords.y)) * 0.15;
   //sum += texture2D(u_texture, vec2(v_texCoords.x + 2.0*blurSize, v_texCoords.y)) * 0.12;
   //sum += texture2D(u_texture, vec2(v_texCoords.x + 3.0*blurSize, v_texCoords.y)) * 0.09;
   //sum += texture2D(u_texture, vec2(v_texCoords.x + 4.0*blurSize, v_texCoords.y)) * 0.05;

   int j;
   int i;

   vec4 temp = vec4(0.0);

   for( i= -4 ;i < 4; i++)
   {
      for (j = -3; j < 3; j++)
      {
         temp = texture2D(u_texture, v_texCoords + vec2(j, i)*0.004) * 0.25;

         sum += temp * temp.a;
      }
   }
   //if (texture2D(u_texture, v_texCoords).r < 0.3)
   //{
   //   gl_FragColor = sum*sum*0.012 + texture2D(u_texture, v_texCoords);
   //}
   //else
   //{
   //   if (texture2D(u_texture, v_texCoords).r < 0.5)
   //   {
   //      gl_FragColor = sum*sum*0.009 + texture2D(u_texture, v_texCoords);
   //   }
   //   else
   //   {
   //      gl_FragColor = sum*sum*0.0075 + texture2D(u_texture, v_texCoords);
   //   }
   //}

   gl_FragColor = v_color * sum;
}