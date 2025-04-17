/*
// Input: Texture coordinates (automatically provided by Hyprland)
in vec2 texCoord;

// Input: Screen texture sampler (automatically provided by Hyprland)
uniform sampler2D tex;

// Output: Final fragment color for the screen
out vec4 fragColor;

// --- Constants for Luminance Calculation (Rec. 709) ---
// Standard weights for perceived brightness
const vec3 LUMINANCE_WEIGHTS = vec3(0.2126, 0.7152, 0.0722);

void main() {
    // 1. Sample the screen content at the current fragment's position
    vec4 originalColor = texture(tex, texCoord);

    // 2. Calculate the grayscale value (luminance)
    float gray = dot(originalColor.rgb, LUMINANCE_WEIGHTS);

    // 3. Output the grayscale color.
    // We construct a vec3 with R, G, and B all set to the 'gray' value,
    // and keep the original alpha component (usually 1.0 for opaque screen content).
    fragColor = vec4(vec3(gray), originalColor.a);
}
*/


// Grayscale shader for use with Hyprland's screen_shader option

precision highp float;
varying vec2 v_texcoord;
uniform sampler2D tex; // Input: Screen texture sampler (automatically provided by Hyprland)
const vec3 LUMINANCE_WEIGHTS = vec3(0.2126, 0.7152, 0.0722); // Standard weights for perceived brightness

void main() {
  vec4 normal = texture2D( tex, v_texcoord ); 
  float greyscale = dot(normal.rgb, LUMINANCE_WEIGHTS); //float greyscale = (normal.r + normal.g + normal.b) / 3.0
  gl_FragColor = vec4(greyscale, greyscale, greyscale, 1.0);
}
