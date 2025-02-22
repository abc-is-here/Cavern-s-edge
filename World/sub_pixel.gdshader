shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform float glow_intensity : hint_range(0.0, 1.5) = 0.8;
uniform float color_shift_amount : hint_range(0.0, 0.1) = 0.03;
uniform float vignette_strength : hint_range(0.0, 2.0) = 0.6;

uniform float wave_strength : hint_range(0.0, 0.05) = 0.03;
uniform float wave_speed : hint_range(0.0, 5.0) = 1.5;
uniform float chromatic_aberration : hint_range(0.0, 0.02) = 0.008;
uniform float noise_intensity : hint_range(0.0, 0.1) = 0.02;

uniform int bubble_count = 5;
uniform float bubble_size : hint_range(0.02, 0.2) = 0.05;
uniform float bubble_speed : hint_range(0.5, 3.0) = 1.2;
uniform float bubble_opacity : hint_range(0.1, 1.0) = 0.6;

vec3 shift_color(vec3 color, float amount) {
    return vec3(
        color.r + amount * 0.5,
        color.g - amount * 0.2,
        color.b + amount * 0.3
    );
}

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

float bubble(vec2 uv, vec2 position, float size) {
    float dist = length(uv - position);
    return smoothstep(size, size * 0.6, dist);
}

void fragment() {
    float time = TIME * wave_speed;

    vec2 wave_offset = vec2(
        sin(SCREEN_UV.y * 12.0 + time) * wave_strength + cos(SCREEN_UV.x * 8.0 + time * 0.7) * wave_strength,
        cos(SCREEN_UV.x * 10.0 + time * 1.2) * wave_strength + sin(SCREEN_UV.y * 6.0 + time * 0.5) * wave_strength
    );
    vec2 distorted_uv = SCREEN_UV + wave_offset;

    vec4 color_r = texture(SCREEN_TEXTURE, distorted_uv + vec2(chromatic_aberration, 0.0));
    vec4 color_g = texture(SCREEN_TEXTURE, distorted_uv);
    vec4 color_b = texture(SCREEN_TEXTURE, distorted_uv - vec2(chromatic_aberration, 0.0));

    vec4 base_color = vec4(color_r.r, color_g.g, color_b.b, color_g.a);

    vec3 dreamy_color = shift_color(base_color.rgb, color_shift_amount);

    float luminance = dot(dreamy_color, vec3(0.2126, 0.7152, 0.0722));
    dreamy_color += dreamy_color * luminance * glow_intensity;

    float noise = (fract(sin(dot(SCREEN_UV * vec2(123.4, 567.8), vec2(12.34, 56.78))) * 43758.5453) - 0.5) * noise_intensity;
    dreamy_color += noise;

    vec2 uv = SCREEN_UV - 0.5;
    float vignette = 1.0 - dot(uv, uv) * vignette_strength;
    dreamy_color *= vignette;

    float bubbles = 0.0;
    for (int i = 0; i < bubble_count; i++) {
        vec2 bubble_pos = vec2(random(vec2(float(i), 0.1)), random(vec2(float(i), 0.2)));
        bubble_pos.y += mod(time * bubble_speed * random(vec2(float(i), 0.3)), 2.0) - 1.0;

        float size = bubble_size * (0.8 + 0.4 * random(vec2(float(i), 0.4)));
        bubbles += bubble(SCREEN_UV, bubble_pos, size);
    }

    dreamy_color += vec3(1.0, 0.9, 0.8) * bubbles * bubble_opacity;

    COLOR = vec4(dreamy_color, base_color.a);
}
