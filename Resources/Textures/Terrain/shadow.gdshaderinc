// Generates a shadow, while also shrinking the texture by 3x.
// To counterract this, add `VERTEX.xy *= 3.;` in the vertex() function.
vec4 shadow(vec2 texture_pixel_size, vec2 base_uv, float offset, sampler2D tex, float shadow_intensity) {
	mat2 scale_matrix = mat2(vec2(1.0, 0.0),vec2(0.0, texture_pixel_size.x/texture_pixel_size.y));
	vec2 uv = (((base_uv * 2.0 - 1.0)*3.+1.0)/2.0-vec2(0.5))*scale_matrix;
	vec2 uv_normal = uv * inverse(scale_matrix) + vec2(0.5);
	uv = (uv + vec2(0.25)*offset)*inverse(scale_matrix)+vec2(0.5);
	vec4 shadow;
	vec4 real;
	if(offset != 0.0 && uv.x >= 0.0 && uv.x <= 1.0 && uv.y >= 0.0 && uv.y <= 1.0) {
		vec4 c = texture(tex, uv);
		shadow = vec4(0.,0.,0.,c.a-(1.0 - shadow_intensity));
	}
	if(uv_normal.x >= 0.0 && uv_normal.x <= 1.0 && uv_normal.y >= 0.0 && uv_normal.y <= 1.0) {
		real = texture(tex,uv_normal);
	}
	return mix(shadow,real,real.a);
}