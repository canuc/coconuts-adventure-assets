#version 310 es

precision highp float;
in vec4 v_Color;

layout (location = 0) out vec4 FragColor;
layout (location = 1) out vec4 BrightColor;

void main()
{
   FragColor = v_Color;
   BrightColor = FragColor;
}
