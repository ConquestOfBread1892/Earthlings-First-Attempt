class_name PlayerFlyState extends BaseState

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

func _init(player):
	super._init(player)
	original_layer = entity.collision_layer
	
func enter():
	flying_mode()

func flying_mode():
	var flying_z_index = 4
	entity.collision_layer = 0  # Clear all layers
	entity.set_collision_layer_value(FLYING_LAYER, true) # Set flying layer
	
	entity.set_collision_mask_value(HEIGHT0_LAYER, false)
	entity.set_collision_mask_value(PLAYER_LAYER, false)
	entity.set_collision_mask_value(ACTIVE_FRIEND_LAYER, false)
	entity.set_collision_mask_value(WORLD_OBJECT_LAYER, false)
	entity.player_animation_controller.z_index = flying_z_index
	entity.player_eye.z_index = flying_z_index

func exit():
	grounded_mode()
	

func grounded_mode():
	entity.collision_layer = original_layer
	
	entity.set_collision_mask_value(HEIGHT0_LAYER, true)
	entity.set_collision_mask_value(PLAYER_LAYER, true)
	entity.set_collision_mask_value(ACTIVE_FRIEND_LAYER, true)
	entity.set_collision_mask_value(WORLD_OBJECT_LAYER, true)
	entity.player_animation_controller.z_index = entity.player_animation_controller.base_z_index
	entity.player_eye.z_index = entity.player_eye.base_z_index
	
func update(delta):
	# Calculate velocity with increased speed for flying
	var fly_speed_multiplier = 4 
	entity.velocity = entity.normalized_velocity * entity.get_speed() * fly_speed_multiplier * delta

func get_transition():
	# This would be checked by form-specific logic in handle_input
	# The default fly state doesn't transition automatically
	return null

func handle_input(event):
	# Check if the fly button is released
	if "fly" in entity.capabilities:
		if event.is_action_released("form_ability"):
			if entity.velocity != Vector2.ZERO:
				return "walk"
			else:
				return "idle"
		return null
