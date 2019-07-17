#version 300 es

precision highp float;
layout (location = 0) out vec4 FragColor;
in vec2 v_texCoord;

uniform sampler2D u_texture;
uniform bool u_horizontal;

const float weight[5] = float[] (0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162);

void main()
{
     ivec2 tex_size = textureSize(u_texture, 0);
     vec2 tex_offset = vec2( (1.0 / float(tex_size.x)),(1.0 / float(tex_size.y)) ); // gets size of single texel
     vec3 result = texture(u_texture, v_texCoord).rgb * weight[0];
     if(u_horizontal)
     {
         for(int i = 1; i < 5; ++i)
         {
            result += texture(u_texture, v_texCoord + vec2(tex_offset.x * float(i), 0.0)).rgb * weight[i];
            result += texture(u_texture, v_texCoord - vec2(tex_offset.x * float(i), 0.0)).rgb * weight[i];
         }
     }
     else
     {
         for(int i = 1; i < 5; ++i)
         {
             result += texture(u_texture, v_texCoord + vec2(0.0, tex_offset.y * float(i))).rgb * weight[i];
             result += texture(u_texture, v_texCoord - vec2(0.0, tex_offset.y * float(i))).rgb * weight[i];
         }
     }

     FragColor = vec4(result, 1.0);
}