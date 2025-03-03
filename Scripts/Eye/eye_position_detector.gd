class_name EyePositionDetector extends Node

# The color to look for (bright magenta by default)
var marker_color = Color(1.0, 0.0, 1.0)  # FF00FF in hex
var marker_threshold = 0.1  # Color matching tolerance

# Cache for previously analyzed frames
var position_cache = {}

# Find the eye position for a given sprite frame
func find_eye_position(sprite: AnimatedSprite2D) -> Vector2:
	# Create a unique key for this frame
	var cache_key = sprite.animation + "_" + str(sprite.frame) + "_" + str(sprite.flip_h)
	
	# Return cached position if we've seen this frame before
	if position_cache.has(cache_key):
		return position_cache[cache_key]
	
	# Get the texture for the current frame
	var texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	
	# We need to get the image data to analyze pixels
	var image = texture.get_image()
	
	# Search for the marker pixel
	var found_position = Vector2.ZERO
	var found = false
	
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var pixel = image.get_pixel(x, y)
			
			# Check if this pixel is close to our marker color
			if color_match(pixel, marker_color, marker_threshold):
				# Found the marker! Calculate position relative to sprite center
				var sprite_center = Vector2(texture.get_width() / 2, texture.get_height() / 2)
				found_position = Vector2(x, y) - sprite_center
				
				# Flip the X position if the sprite is flipped
				if sprite.flip_h:
					found_position.x = -found_position.x
				
				found = true
				break
		
		if found:
			break
	
	# Cache this result for future frames
	position_cache[cache_key] = found_position
	return found_position

# Determine if a color matches our target within the threshold
func color_match(color1: Color, color2: Color, threshold: float) -> bool:
	return (
		abs(color1.r - color2.r) < threshold and
		abs(color1.g - color2.g) < threshold and
		abs(color1.b - color2.b) < threshold
	)
