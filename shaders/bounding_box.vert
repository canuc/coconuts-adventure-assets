#version 300 es

precision highp float;
uniform mat4 u_MMatrix;
uniform mat4 u_PMatrix;
uniform mat4 u_VMatrix;

attribute vec3 a_Position;

varying vec4 v_Color;

void main() {
	v_Color   = vec4(1.0,1.0,1.0,1.0);
    gl_PointSize = 2.0;
	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * vec4(a_Position,1.0);
}
