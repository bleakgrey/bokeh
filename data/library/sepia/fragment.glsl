// Sepia filter
// Original by https://github.com/spite/Wagner

uniform sampler2D u_texture1;

uniform float amount;

void mainImage(out vec4 fragColor, vec2 fragCoord, vec2 resolution, vec2 uv) {
	vec4 color = GskTexture(u_texture1, uv);
	float r = color.r;
	float g = color.g;
	float b = color.b;
	
	color.r = min(1.0, (r * (1.0 - (0.607 * amount))) + (g * (0.769 * amount)) + (b * (0.189 * amount)));
	color.g = min(1.0, (r * 0.349 * amount) + (g * (1.0 - (0.314 * amount))) + (b * 0.168 * amount));
	color.b = min(1.0, (r * 0.272 * amount) + (g * 0.534 * amount) + (b * (1.0 - (0.869 * amount))));
	
	fragColor = color;
}

