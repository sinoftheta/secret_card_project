shader_type canvas_item;
uniform vec4 shadow_color;

void fragment() {
	if(COLOR.a != 0.0){
		COLOR = shadow_color;
	}
}
