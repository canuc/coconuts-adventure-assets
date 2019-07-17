#version 300 es
precision highp float;
out vec4 FragColor;
in vec2 v_texCoord;

uniform sampler2D u_texture;
uniform sampler2D u_bump;

void main()
{
    const float gamma = 1.4;
    const float exposure = 0.5;

    vec3 hdrColor = texture(u_texture, v_texCoord).rgb;
    vec3 bloomColor = texture(u_bump, v_texCoord).rgb;

    hdrColor += bloomColor; // additive blending
    // tone mapping
    vec3 result = vec3(1.0) - exp(-hdrColor * exposure);
    // also gamma correct while we're at it
    result = pow(result, vec3(1.0 / gamma));
    FragColor = vec4(result, 1.0f);
}