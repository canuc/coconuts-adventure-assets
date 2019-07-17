#version 300 es

precision highp float;
const float PI = 3.1415926535897932384626433832795;
const vec2 u_k = vec2(200.0,200.0);
uniform sampler2D u_texture;

in vec2 v_texCoord;
in highp vec2 v_coords;
in highp float v_time;

layout (location = 0) out vec4 FragColor;
layout (location = 1) out vec4 BrightColor;

void main() {
    highp float v = 0.0;
    vec2 c = v_coords * u_k - u_k/2.0;
    v += sin((c.x+v_time));
    v += sin((c.y+v_time)/2.0);
    v += sin((c.x+c.y+v_time)/2.0);
    c += u_k/2.0 * vec2(sin(v_time/3.0), cos(v_time/2.0));
    v += sin(sqrt(c.x*c.x+c.y*c.y+1.0)+v_time);
    v = v/2.0;
    vec3 col = vec3(1, sin(PI*v), cos(PI*v));

    FragColor = vec4(col*.5 + .5, 1) * texture(u_texture, v_texCoord);

    float brightness = dot(vec3(FragColor), vec3(0.2126, 0.7152, 0.0722));

    BrightColor = FragColor * 2.0;
}