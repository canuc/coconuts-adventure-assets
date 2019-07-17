#version 300 es

precision highp float;
uniform mat4 u_MMatrix;
uniform mat4 u_PMatrix;
uniform vec4 u_color;

in vec2 a_Position;
in vec2 a_texCoord;

out vec4 v_color;
out vec2 v_texCoord;

void main()   {
    v_texCoord = a_texCoord;
    v_color = u_color;
	gl_Position = u_PMatrix * u_MMatrix * vec4(a_Position,0.0,1.0);
}
