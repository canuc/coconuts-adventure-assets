#version 300 es

precision highp float;
const float PI = 3.1415926535897932384626433832795;
uniform highp mat4 u_MMatrix;
uniform highp mat4 u_PMatrix;
uniform highp mat4 u_VMatrix;
uniform float u_time;

in vec3 a_Position;
in vec3 a_Color;
in vec2 a_texCoord;

out vec4 v_Color;
out vec2 v_texCoord;
out highp float v_time;
out highp vec2 v_coords;

void main() {
    v_Color = vec4(a_Color,1.0);
    v_texCoord = a_texCoord;
    v_coords = a_texCoord;
    v_time = mod(u_time/1500.0,12.0 * PI);
    gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * vec4(a_Position,1.0);
}