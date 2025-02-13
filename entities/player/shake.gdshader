shader_type canvas_item;

uniform float intensity : hint_range(0.0, 10.0) = 5.0;
uniform float speed : hint_range(0.0, 20.0) = 30.0;
uniform bool enable_vibration = false;

// Hash function to generate pseudo-random values
float random(float seed) {
    return fract(sin(seed * 43758.5453123) * 43758.5453123);
}

void vertex() {
    if (enable_vibration) {

	    float time_offset = TIME * speed;
	    float rand_x = random(time_offset);
	    float rand_y = random(time_offset + 10.0); // Slight variation for Y axis

	    float offset_x = sin(time_offset) * intensity * rand_x;
	    float offset_y = cos(time_offset) * intensity * rand_y;

	    VERTEX += vec2(offset_x, offset_y);
    }
}
