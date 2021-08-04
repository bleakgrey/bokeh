// Invert filter

uniform sampler2D u_texture1;

void mainImage(out vec4 fragColor, vec2 fragCoord, vec2 resolution, vec2 uv) {
	vec4 color = GskTexture(u_texture1, uv);
	color.rgb = 1.0 - color.rgb;
	fragColor = color;
}

