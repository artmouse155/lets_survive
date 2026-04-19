// SOURCE: https://godotshaders.com/shader/2d-topdown-shadow-that-goes-out-of-bounds/

shader_type canvas_item;

#include "shadow.gdshaderinc"

uniform float offset: hint_range(0.0, 1.0) = 0.0;
uniform float shadow_intensity: hint_range(0.0, 1.0) = 0.4;

void vertex() {
	VERTEX.xy *= 3.;
}

void fragment() {
	COLOR = shadow(TEXTURE_PIXEL_SIZE, UV, offset, TEXTURE, shadow_intensity);
}