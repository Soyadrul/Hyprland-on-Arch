#version 300 es

precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex; // Input: Screen texture sampler (automatically provided by Hyprland)
out vec4 fragColor;

void main() {
  vec4 normal = texture2D( tex, v_texcoord); 
  vec3 inverted = vec3(1.0 - normal.r, 1.0 - normal.g, 1.0 - normal.b);
  
  fragColor = vec4(inverted, 1.0 - normal.a);
}
