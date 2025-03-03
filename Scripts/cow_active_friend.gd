class_name CowActiveFriend extends BaseActiveFriend


func _ready() -> void:
	super._ready()
	cow_active_friend_signals_connect()
	GameEvents.input_manager_friend_ability_just_pressed.connect(spawn_cow)
	capabilities.append("push")

	
		
func _on_tree_entered():
	GameEvents.input_manager_friend_ability_just_pressed.connect(spawn_cow)
	
	
func _on_tree_exiting():
	GameEvents.input_manager_friend_ability_just_pressed.disconnect(spawn_cow)
	

func cow_active_friend_signals_connect():
		#connect cow to signals
		
	tree_entered.connect(_on_tree_entered)
	tree_exiting.connect(_on_tree_exiting)
	
func spawn_cow():
	# Create a deep duplicate of the current node
	# The true parameter means it will be a "deep" copy - copying all child nodes too
	var new_cow = self.duplicate(true)
	
	# Give the new player a unique name to avoid conflicts
	new_cow.name = "Player_" + str(get_parent().get_child_count())
	
	# Offset the position so it doesn't spawn exactly on top of the original
	new_cow.position = position + facing_direction_and_distance(50)  # Spawns 50 pixels to the right
	
	# Add the new player to the same parent as the original player
	get_parent().add_child(new_cow)

func facing_direction_and_distance(amount_param):
	if active_friend_animation_controller.direction == "left":
		return Vector2(-amount_param, 0)
	elif active_friend_animation_controller.direction == "right":
		return Vector2(amount_param, 0)

func get_friend_name():
	return "cow"


func get_speed():
	return 6000
