shader_type canvas_item;

// Control value from 0.0 (perfect) to 1.0 (shattered/invisible)
uniform float break_progress : hint_range(0.0, 1.0) = 0.0;

// Assign a FastNoiseLite texture here in the inspector
uniform sampler2D noise_texture : repeat_enable, filter_linear;

// Controls how wide the structural crack lines are
uniform float crack_width : hint_range(0.01, 0.2) = 0.05;

void fragment() {
	// Sample the original sprite texture
	vec4 tex_color = texture(TEXTURE, UV);
	
	// Sample the noise values (returns 0.0 to 1.0)
	float noise_val = texture(noise_texture, UV).r;
	
	// Scale the threshold so it fully clears at 1.0 progress
	float threshold = break_progress * 1.1;
	
	// 1. Core break lines: Create holes where noise is less than the threshold
	if (noise_val < threshold) {
		discard;
	}
	
	// 2. Secondary branching cracks: Cut narrow fractal slits just ahead of the holes
	// This acts as a secondary mask layer that carves structural lines into the sprite
	if (break_progress > 0.0) {
		float crack_line = abs(noise_val - threshold);
		if (crack_line < crack_width * (1.0 - break_progress)) {
			discard;
		}
	}
	
	// Output your original sprite's clean colors untouched
	COLOR = tex_color;
}
