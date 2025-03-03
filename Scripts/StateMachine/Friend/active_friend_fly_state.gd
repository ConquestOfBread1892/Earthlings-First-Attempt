class_name ActiveFriendFlyState extends BaseState

## Define layers for clarity
#const PLAYER_LAYER = 1
#const ACTIVE_FRIEND_LAYER = 4
#const PASSIVE_FRIEND_LAYER = 7
#const WORLD_OBJECT_LAYER = 10
#const FLYING_LAYER = 28
#const HEIGHT3_LAYER = 29 
#const HEIGHT2_LAYER= 30
#const HEIGHT1_LAYER = 31 
#const HEIGHT0_LAYER = 32

var original_layer

func _init(friend):
	super._init(friend)
	original_layer = entity.collision_layer


func enter():
	# Adjust collision mask when flying (from your original code)
	flying_mode()
	# Additional fly state setup could go here
	# For example, lifting animation would be triggered by animation controller

func flying_mode():
	entity.collision_layer = 0  # Clear all layers
	entity.set_collision_layer_value(FLYING_LAYER, true) # Set flying layer
	
	entity.set_collision_mask_value(HEIGHT0_LAYER, false)
	entity.set_collision_mask_value(PLAYER_LAYER, false)
	entity.set_collision_mask_value(ACTIVE_FRIEND_LAYER, false)
	entity.set_collision_mask_value(WORLD_OBJECT_LAYER, false)
	entity.active_friend_animation_controller.z_index = 4
	entity.active_friend_animation_controller.lift_off_tween()



func exit():
	# Restore collision mask when exiting fly state
	grounded_mode()

func grounded_mode():
	entity.collision_layer = original_layer
	
	entity.set_collision_mask_value(HEIGHT0_LAYER, true)
	entity.set_collision_mask_value(PLAYER_LAYER, true)
	entity.set_collision_mask_value(ACTIVE_FRIEND_LAYER, true)
	entity.set_collision_mask_value(WORLD_OBJECT_LAYER, true)
	entity.active_friend_animation_controller.z_index = entity.active_friend_animation_controller.base_z_index
	entity.active_friend_animation_controller.play_landing_tween()


func update(delta):
	# Calculate velocity with increased speed for flying
	var fly_speed_multiplier = 4
	entity.velocity = entity.input_direction * entity.get_speed() * fly_speed_multiplier * delta
	
	# Play fly animation
	entity.active_friend_animation_controller.play_fly_animation(entity.velocity)

func handle_input(event):
	# Check if the fly button is released
	if "fly" in entity.capabilities:
		if event.is_action_released("friend_ability"):
			if entity.velocity != Vector2.ZERO:
				return "walk"
			else:
				return "idle"
		return null
		
	# Check for next/prev actions that should exit flying
	var stop_flying_actions = ["next", "prev"]
	for action in stop_flying_actions:
		if event.is_action_pressed(action):
			return "idle"
			
	return null
