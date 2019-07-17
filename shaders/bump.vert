#version 300 es
precision highp float;
uniform highp mat4 u_MMatrix;
uniform highp mat4 u_PMatrix;
uniform highp mat4 u_VMatrix;
uniform vec3 u_eyeVec;

attribute vec3 a_Position;
attribute vec3 a_Color;
attribute vec2 a_texCoord;
attribute vec3 a_bitangent;
attribute vec3 a_tangent;
attribute vec3 a_normal;

varying vec2 v_texCoord;
varying vec3 Position_worldspace;
varying vec3 EyeDirection_cameraspace;
varying vec3 LightDirection_cameraspace;
varying mat4 v_modelViewProjection;

varying vec3 LightDirection_tangentspace;
varying vec3 EyeDirection_tangentspace;

mat3 transpose_compat(mat3 m) {
  return mat3(  m[0][0], m[1][0], m[2][0],  // new col 0
                m[0][1], m[1][1], m[2][1],  // new col 1
                m[0][2], m[1][2], m[2][2]   // new col 1
             );
}

void main() {
    v_texCoord = a_texCoord;
    v_modelViewProjection = u_PMatrix * u_VMatrix * u_MMatrix;
    gl_Position = v_modelViewProjection * vec4(a_Position,1.0);

    mat3 cameraSpaceTransformation = mat3(u_VMatrix * u_MMatrix);
    Position_worldspace = (u_MMatrix * vec4(a_Position,1.0)).xyz;

    vec3 vertexPosition_cameraspace = ( u_VMatrix * u_MMatrix * vec4(a_Position,1)).xyz;
    EyeDirection_cameraspace = vec3(0,0,0) - vertexPosition_cameraspace;

    vec3 vertexTangent_cameraspace = cameraSpaceTransformation * a_tangent;
    vec3 vertexBitangent_cameraspace = cameraSpaceTransformation * a_bitangent;
    vec3 vertexNormal_cameraspace = cameraSpaceTransformation * a_normal;

    mat3 TBN = transpose_compat(mat3(
        vertexTangent_cameraspace,
        vertexBitangent_cameraspace,
        vertexNormal_cameraspace
    ));

    vec3 LightPosition_cameraspace = ( u_VMatrix * vec4(u_eyeVec,1.0)).xyz;
    LightDirection_cameraspace = LightPosition_cameraspace + EyeDirection_cameraspace;

    LightDirection_tangentspace = TBN * LightDirection_cameraspace;
    EyeDirection_tangentspace =  TBN * EyeDirection_cameraspace;
}