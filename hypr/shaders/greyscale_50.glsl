// Grayscale shader (50%) for use with Hyprland's screen_shader option

#version 300 es
precision mediump float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    vec4 pixelColor = texture(tex, v_texcoord);
    float grey = dot(pixelColor.rgb, vec3(0.2126, 0.7152, 0.0722));
    
    vec3 desat;
    desat = mix(pixelColor.rgb, vec3(grey), 0.5); // Greyscale at 50%
    
    fragColor = vec4(desat, pixelColor.a);
}
