// Vignette filter
// Original by https://github.com/spite/Wagner

uniform sampler2D u_texture1;

const float falloff = 0.35;
const float amount = 0.25;

void mainImage(out vec4 fragColor, vec2 fragCoord, vec2 resolution, vec2 uv) {
    vec4 color = GskTexture(u_texture1, uv);
    
    float dist = distance(uv, vec2(0.5, 0.5));
    color.rgb *= smoothstep(0.8, falloff * 0.799, dist * (amount + falloff));
    
    fragColor = color;
}
