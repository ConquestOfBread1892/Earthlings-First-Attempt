shader_type canvas_item;

// Core parameters
uniform vec4 fabric_color : source_color = vec4(0.93, 0.89, 0.82, 1.0); // Fabric background color
uniform bool use_screen_texture = true;  // Use this for full-screen effects
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Stitch appearance
uniform float stitch_density : hint_range(0.5, 2.0) = 1.0;     // Controls how many stitches appear (higher = more stitches)
uniform float stitch_thickness : hint_range(0.3, 0.9) = 0.7;   // Make stitches very thick to fill space
uniform float grid_width : hint_range(0.0, 0.2) = 0.03;        // Very thin grid lines to minimize background
uniform float color_reduction : hint_range(1.0, 32.0) = 8.0;   // How many colors to use
uniform float stitch_brightness : hint_range(0.8, 1.5) = 1.2;  // Brighten stitches to make them stand out
uniform float fabric_visibility : hint_range(0.0, 0.3) = 0.08; // How much fabric shows through (lower = less background)

// Returns a pseudo-random value between 0 and 1 for a given 2D position
float random(vec2 pos) {
    return fract(sin(dot(pos.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

// Quantizes a color to a reduced palette
vec3 quantize_color(vec3 color, float levels) {
    // Enhance contrast before quantizing
    color = pow(color, vec3(0.85)); // Slightly increase contrast
    color = (color - 0.4) * 1.2 + 0.4; // Increase contrast further
    color = clamp(color, 0.0, 1.0); // Make sure we stay in valid range
    return floor(color * levels + 0.5) / levels;
}

// Creates a dense cross-stitch pattern to fill space
float dense_cross_stitch(vec2 uv, float size, float thickness) {
    // Calculate grid position
    vec2 grid_pos = fract(uv * size);
    
    // Create thick X pattern to fill more space
    float diagonal1 = abs(grid_pos.x - grid_pos.y);
    float diagonal2 = abs(grid_pos.x - (1.0 - grid_pos.y));
    
    // Use thicker lines to minimize background
    float stitch1 = 1.0 - smoothstep(thickness * 0.9, thickness, diagonal1);
    float stitch2 = 1.0 - smoothstep(thickness * 0.9, thickness, diagonal2);
    
    // Combine the diagonals
    float stitch = max(stitch1, stitch2);
    
    // Add subtle variations for a handmade look
    float variation = random(uv * 8.0) * 0.05;
    stitch = clamp(stitch + variation, 0.0, 1.0);
    
    return stitch;
}

// Subtle fabric texture that won't be very visible
float subtle_fabric_texture(vec2 uv, float size) {
    vec2 grid = fract(uv * size * 3.0);
    float weave = sin(grid.x * 3.14159) * sin(grid.y * 3.14159);
    return (weave * 0.5 + 0.5) * 0.2 + 0.8; // Subtle variation
}

void fragment() {
    // Calculate pixel-perfect stitch size based on screen resolution
    float pixel_scale = min(1.0 / SCREEN_PIXEL_SIZE.x, 1.0 / SCREEN_PIXEL_SIZE.y);
    float effective_stitch_size = pixel_scale * stitch_density / 100.0;
    
    // Get screen resolution to maintain aspect ratio
    vec2 ratio = vec2(1.0, SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y);
    
    // Calculate exact pixel position
    vec2 pixelated_uv = floor(UV * effective_stitch_size * ratio) / (effective_stitch_size * ratio);
    vec2 stitch_center = (pixelated_uv + vec2(0.5) / (effective_stitch_size * ratio));
    
    // Sample the appropriate texture
    vec4 original_color;
    if (use_screen_texture) {
        original_color = texture(SCREEN_TEXTURE, stitch_center);
    } else {
        original_color = texture(TEXTURE, stitch_center);
    }
    
    // Create a subtle fabric background texture
    float fabric = subtle_fabric_texture(UV, effective_stitch_size);
    
    // Determine if we're in a very thin grid space
    vec2 grid_pos = fract(UV * effective_stitch_size * ratio);
    float is_grid = 0.0;
    is_grid = float(grid_pos.x < grid_width || grid_pos.x > (1.0 - grid_width) || 
                   grid_pos.y < grid_width || grid_pos.y > (1.0 - grid_width));
    
    // Calculate dense cross-stitch pattern
    float stitch = dense_cross_stitch(UV, effective_stitch_size * ratio.x, stitch_thickness);
    
    // Reduce the color palette for a true cross-stitch look
    vec3 quantized_color = quantize_color(original_color.rgb, color_reduction);
    
    // Apply stitch brightness adjustment
    quantized_color *= stitch_brightness;
    
    // Blend the final color with minimal fabric showing
    vec3 final_color;
    if (is_grid > 0.5) {
        // Very thin grid space shows fabric
        final_color = mix(quantized_color, fabric_color.rgb * fabric, fabric_visibility);
    } else {
        // Stitch space shows mostly thread color with just a hint of fabric
        float stitch_alpha = original_color.a * stitch;
        final_color = mix(
            fabric_color.rgb * fabric, 
            quantized_color,
            max(stitch_alpha, 1.0 - fabric_visibility) // Ensure high coverage
        );
    }
    
    // Add a tiny bit of noise for texture
    float noise = random(UV) * 0.03;
    final_color += noise - 0.015;
    
    // Preserve original alpha
    COLOR = vec4(final_color, original_color.a);
}