void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	float amount = 1;

	vec4 color = fragColor;
	float r = color.r;
	float g = color.g;
	float b = color.b;
	
	color.r = min(1.0, (r * (1.0 - (0.607 * amount))) + (g * (0.769 * amount)) + (b * (0.189 * amount)));
	color.g = min(1.0, (r * 0.349 * amount) + (g * (1.0 - (0.314 * amount))) + (b * 0.168 * amount));
	color.b = min(1.0, (r * 0.272 * amount) + (g * 0.534 * amount) + (b * (1.0 - (0.869 * amount))));
	
	fragColor = color;
}
