// Grayscale shader for use with Hyprland's screen_shader option

precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex; // Input: Screen texture sampler (automatically provided by Hyprland)
const vec3 LUMINANCE_WEIGHTS = vec3(0.2126, 0.7152, 0.0722); // Standard weights for perceived brightness
const vec3 RED = vec3(1.0, 0.0, 0.0);

void main() {
  vec4 normal = texture2D( tex, v_texcoord ); 
  float greyscale = dot(normal.rgb, LUMINANCE_WEIGHTS); //float greyscale = (normal.r + normal.g + normal.b) / 3.0
  
  vec3 desat;
  
  desat = mix(normal.rgb, vec3(greyscale), 0.5); // 50% saturazione
  
  gl_FragColor = vec4(desat, normal.a);
}
