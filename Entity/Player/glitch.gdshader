shader_type canvas_item;

uniform float glitch_intensity : hint_range(0.0, 10.0) = 3.0;
uniform float glitch_frequency : hint_range(0.1, 5.0) = 1.5;

float rand(float x) {
    return fract(sin(x * 34567.123) * 45678.654);
}

void fragment() {
    vec2 uv = UV;
    float time_factor = floor(TIME * glitch_frequency);
    float glitch_trigger = rand(time_factor);

    vec4 color = texture(TEXTURE, uv);

    if (glitch_trigger > 0.6) { // 40% chance to glitch
        float offset_amount = 0.02 * glitch_intensity;

        // **Blocky horizontal shifts**
        if (glitch_trigger > 0.7 && fract(UV.y * 10.0) < 0.5) {
            uv.x += offset_amount * (rand(time_factor * 1.2) - 0.5);
        }

        // **Vertical scanline displacement**
        if (glitch_trigger > 0.85 && fract(UV.y * 20.0) < 0.2) {
            uv.y += offset_amount * 0.5;
        }

        // **Jagged pixelation effect**
        if (glitch_trigger > 0.9) {
            uv.x = floor(uv.x * 50.0) / 50.0;
            uv.y = floor(uv.y * 50.0) / 50.0;
        }

        color = texture(TEXTURE, uv);
    }

    COLOR = color;
}
