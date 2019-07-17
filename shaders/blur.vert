#version 300 es
in vec2 a_Position;
in vec2 a_texCoord;

out vec2 v_texCoord;

void main()
{
    gl_Position = vec4(a_Position, 0.0, 1.0);
    v_texCoord = a_texCoord;
}