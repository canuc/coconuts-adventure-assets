#version 300 es

precision highp float;
uniform sampler2D u_texture;

layout (location = 0) out vec4 FragColor;
layout (location = 1) out vec4 BrightColor;

in vec4 v_Color;
in vec2 v_texCoord;

void main()
{
   FragColor = texture(u_texture, v_texCoord);
   BrightColor = vec4(0.0,0.0,0.0,0.0);
}
