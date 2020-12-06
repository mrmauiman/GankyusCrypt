shader_type canvas_item;
render_mode unshaded;

uniform float width : hint_range(0.0, 3.0);
uniform vec4 outline_color : hint_color;

void fragment() {
	float offset = width * (1.0 / float(textureSize(TEXTURE, 0).x));
	
	vec4 sprite_color = texture(TEXTURE, UV);
	float alpha = -8.0 * sprite_color.a;
	
	alpha += texture(TEXTURE, UV + vec2(offset, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(-offset, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(0.0, offset)).a;
	alpha += texture(TEXTURE, UV + vec2(0.0, -offset)).a;
	alpha += texture(TEXTURE, UV + vec2(offset, offset)).a;
	alpha += texture(TEXTURE, UV + vec2(offset, -offset)).a;
	alpha += texture(TEXTURE, UV + vec2(-offset, offset)).a;
	alpha += texture(TEXTURE, UV + vec2(-offset, -offset)).a;
	
	vec4 final_color = mix(sprite_color, outline_color, clamp(alpha, 0.0, 1.0));
	COLOR = vec4(final_color.rgb, clamp(abs(alpha) + sprite_color.a, 0.0, 1.0));
}