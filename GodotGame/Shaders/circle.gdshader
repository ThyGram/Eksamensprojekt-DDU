shader_type canvas_item;
uniform vec4 inner_color: source_color;
uniform vec4 border_color: source_color;
uniform float border_width;

void fragment() {
	float dist = distance(UV.xy, vec2(0.5,0.5));
	if (dist > 0.5)
		COLOR.a = 0.0;
	else if (dist > 0.5 - border_width)
		COLOR = border_color;
	else
		COLOR = inner_color;
}