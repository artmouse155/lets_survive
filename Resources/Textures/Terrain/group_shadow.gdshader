// SOURCE: https://godotshaders.com/shader/2d-topdown-shadow-that-goes-out-of-bounds/

shader_type canvas_item;
render_mode unshaded;

#include "shadow.gdshaderinc"

uniform float offset: hint_range(0.0, 1.0) = 0.0;
uniform float shadow_intensity: hint_range(0.0, 1.0) = 0.4;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void vertex() {
	VERTEX.xy *= 3.;
}

void fragment() {
	vec2 screen_uv = SCREEN_UV + 50. * fwidth(SCREEN_UV);
	vec4 c = textureLod(screen_texture, screen_uv, 0.0);

	if (c.a > 0.0001) {
		c.rgb /= c.a;
	}
	//vec4 color = shadow(SCREEN_PIXEL_SIZE, SCREEN_UV, offset, screen_texture, shadow_intensity);
	//color *= c;
	//COLOR = vec4(UV.x, UV.y, 0., 1.0);
	COLOR *= c;
	//COLOR = color;
}
