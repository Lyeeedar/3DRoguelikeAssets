#ifdef GL_ES
    precision mediump float;
#endif

varying vec4 v_color;
varying vec2 v_texCoords;
uniform sampler2D u_texture;

void main() {

	vec4 sum = vec4(0.0);

   int j;
   int i;

   vec4 temp = vec4(0.0);

   for( i= -4 ; i < 4; i++)
   {
      for (j = -3; j < 3; j++)
      {
         temp = texture2D(u_texture, v_texCoords + vec2(j, i)*0.004) * 0.75;

         sum += temp * temp.a;
      }
   }

   if (texture2D(u_texture, v_texCoords).r < 0.3)
   {
      gl_FragColor.rgb = v_color * sum*sum*0.012 + texture2D(u_texture, v_texCoords);
   }
   else
   {
      if (texture2D(u_texture, v_texCoords).r < 0.5)
      {
         gl_FragColor.rgb = v_color * sum*sum*0.009 + texture2D(u_texture, v_texCoords);
      }
      else
      {
         gl_FragColor.rgb = v_color * sum*sum*0.0075 + texture2D(u_texture, v_texCoords);
      }
   }

   gl_FragColor.a = 1.0;
}