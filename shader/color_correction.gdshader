shader_type canvas_item;
uniform sampler2D screen_texture:hint_screen_texture,repeat_disable,filter_nearest;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 color = texture(screen_texture, SCREEN_UV).rgb;
	color.r = 0.0;

	COLOR.rgb = color;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
