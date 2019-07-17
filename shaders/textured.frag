#version 300 es

precision highp float;
uniform sampler2D u_texture;
in vec2 v_texCoord;

layout (location = 0) out vec4 FragColor;
layout (location = 1) out vec4 BrightColor;

void main()
{
   FragColor = texture(u_texture, v_texCoord);
   float brightness = dot(vec3(FragColor), vec3(0.2126, 0.7152, 0.0722));
   if (brightness > 0.7) {
       BrightColor = FragColor;
   }
}
