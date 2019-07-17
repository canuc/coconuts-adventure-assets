#version 300 es

precision highp float;
uniform sampler2D u_texture;

in vec2 v_texCoord;
in vec4 v_color;

layout (location = 0) out vec4 FragColor;
layout (location = 1) out vec4 BrightColor;

void main()
{
   FragColor = v_color.a * texture(u_texture, v_texCoord).a * v_color;
   BrightColor = vec4(0.0,0.0,0.0,0.0);
}
