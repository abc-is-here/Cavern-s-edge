shader_type canvas_item;

uniform vec4 laser_color = vec4(1.0, 0.0, 0.0, 1.0); // Red laser
uniform float glow_intensity = 1.5;
uniform float speed = 3.0;
uniform float noise_scale = 20.0;

void fragment() {
    float uv_x = UV.x;

    // Create a glow effect by fading from the center outwards
    float glow = smoothstep(0.5, 0.0, abs(uv_x - 0.5)) * glow_intensity;

    // Animated flicker effect using sine wave
    float flicker = 0.5 + 0.5 * sin(TIME * speed + UV.y * noise_scale);
    glow *= flicker;

    vec4 final_color = laser_color * glow;
    COLOR = vec4(final_color.rgb, final_color.a);
}
