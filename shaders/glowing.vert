#version 300 es

precision highp float;
uniform mat4 u_MMatrix;
uniform mat4 u_PMatrix;
uniform mat4 u_VMatrix;
uniform float u_time;
uniform float period;

in vec3 a_Position;
in vec3 a_Color;
in vec2 a_texCoord;

out vec4 v_Color;
out vec2 v_texCoord;
out float v_period;
#define M_PI 3.1415926535897932384626433832795

void main() {
    v_Color = vec4(a_Color,1.0);
    v_texCoord = a_texCoord;
    v_period = (mod(u_time, period) / period);
    v_texCoord.x = a_texCoord.x + v_period;

	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * vec4(a_Position,1.0);
}
