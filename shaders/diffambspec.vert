#version 300 es

precision highp float;
uniform highp mat4 u_MMatrix;
uniform highp mat4 u_PMatrix;
uniform highp mat4 u_VMatrix;

in vec3 a_Position;
in vec3 a_Color;
in vec2 a_texCoord;

out vec4 v_Color;
out vec2 v_texCoord;

void main() {
    v_Color = vec4(a_Color,1.0);
    v_texCoord = a_texCoord;
    gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * vec4(a_Position,1.0);
}

