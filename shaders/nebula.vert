#version 300 es

precision highp float;
uniform mat4 u_MMatrix;
uniform mat4 u_PMatrix;
uniform mat4 u_VMatrix;
uniform vec3 u_eyeVec;
uniform vec3 u_position;

in vec3 a_Position;
in vec2 a_texCoord;
in vec3 a_normal;

out vec2 v_texCoord;
out vec4 v_eyeVec;
out vec4 v_normal;
out vec4 v_color;

void main() {
    mat4 transformation = u_PMatrix * u_VMatrix * u_MMatrix;
    v_eyeVec = normalize(vec4(u_eyeVec,1.0) - (vec4(a_Position,1.0)));
    v_texCoord = a_texCoord;
    v_normal = normalize(vec4(a_normal,1.0));
	gl_Position =  transformation * vec4(a_Position,1.0);
}
