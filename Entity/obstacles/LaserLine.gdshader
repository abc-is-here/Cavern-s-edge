shader_type canvas_item;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    color.rgb = vec3(1.5, 0.0, 0.0);
    color.a *= smoothstep(0.2, 1.0, color.a);
    COLOR = color;
}
