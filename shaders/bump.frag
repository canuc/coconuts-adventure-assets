#version 300 es
precision highp float;
uniform highp mat4 u_MMatrix;
uniform highp mat4 u_PMatrix;
uniform highp mat4 u_VMatrix;
uniform vec3 u_eyeVec;

varying vec2 v_texCoord;
varying vec3 Position_worldspace;
varying vec3 EyeDirection_cameraspace;
varying vec3 LightDirection_cameraspace;
varying mat4 v_modelViewProjection;

varying vec3 LightDirection_tangentspace;
varying vec3 EyeDirection_tangentspace;

uniform sampler2D u_texture;
uniform sampler2D u_bump;

float clamp_compat(float bumpM) {
	return (bumpM < 0.0) ? 0.0 : (bumpM > 1.0)? 1.0 : bumpM;
}

void main(){

	// Light emission properties
	// You probably want to put them as uniforms
	vec3 LightColor = vec3(1,1,1);
	float LightPower = 25.0;

	// Material properties
	vec3 MaterialDiffuseColor = texture2D( u_texture, v_texCoord ).rgb;
	vec3 MaterialAmbientColor = vec3(0.1,0.1,0.1) * MaterialDiffuseColor;

	// Local normal, in tangent space. V tex coordinate is inverted because normal map is in TGA (not in DDS) for better quality
	vec3 TextureNormal_tangentspace = normalize(texture2D( u_bump, v_texCoord ).rgb*2.0 - 1.0);

	// Distance to the light
	float distance = length( u_eyeVec - Position_worldspace );

	// Normal of the computed fragment, in camera space
	vec3 n = TextureNormal_tangentspace;
	// Direction of the light (from the fragment to the light)
	vec3 l = normalize(LightDirection_tangentspace);
	// Cosine of the angle between the normal and the light direction,
	// clamped above 0
	//  - light is at the vertical of the triangle -> 1
	//  - light is perpendicular to the triangle -> 0
	//  - light is behind the triangle -> 0
	float cosTheta = clamp_compat( dot( n,l ) );

	// Eye vector (towards the camera)
	vec3 E = normalize(EyeDirection_tangentspace);
	// Direction in which the triangle reflects the light
	vec3 R = reflect(-l,n);
	// Cosine of the angle between the Eye vector and the Reflect vector,
	// clamped to 0
	//  - Looking into the reflection -> 1
	//  - Looking elsewhere -> < 1
	float cosAlpha = clamp_compat( dot( E,R ) );

	vec3 colorComp =
		// Ambient : simulates indirect lighting
		MaterialAmbientColor +
		// Diffuse : "color" of the object
		MaterialDiffuseColor * LightColor * LightPower * cosTheta / (distance*distance);
	gl_FragColor = vec4(colorComp,1.0);
}
