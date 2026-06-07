// Grayscale shader (100%) for use with Hyprland's screen_shader option

#version 300 es
precision mediump float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    vec4 pixelColor = texture(tex, v_texcoord);
    float grey = dot(pixelColor.rgb, vec3(0.2126, 0.7152, 0.0722));
    fragColor = vec4(grey, grey, grey, pixelColor.a);
}
