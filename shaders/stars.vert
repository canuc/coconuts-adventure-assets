#version 310 es

precision highp float;
uniform mat4 u_MMatrix;
uniform mat4 u_PMatrix;
uniform mat4 u_VMatrix;

in vec3 a_Position;

out vec4 v_Color;

void main()   {
	v_Color   = vec4(1.0,1.0,1.0,1.0);
    gl_PointSize = abs(a_Position.z) * 5.0;
	gl_Position = vec4(a_Position,1.0);
}
