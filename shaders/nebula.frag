#version 310 es

precision highp float;
uniform sampler2D u_texture;

layout (location = 0) out vec4 FragColor;
layout (location = 1) out vec4 BrightColor;

in vec2 v_texCoord;
in vec4 v_eyeVec;
in vec4 v_normal;
in vec4 v_color;

void main()
{
    FragColor = texture(u_texture, v_texCoord) * abs(dot(v_normal,v_eyeVec));
    BrightColor = FragColor;
}
