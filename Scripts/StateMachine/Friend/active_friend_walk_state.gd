class_name ActiveFriendWalkState extends BaseState

func _init(friend):
	super._init(friend)

func enter():
	# Animation will be handled in update
	pass

func update(delta):
	# Calculate velocity based on input direction and speed
	entity.velocity = entity.input_direction * entity.get_speed() * delta
	
	# Play walk animation
	entity.active_friend_animation_controller.play_walk_animation(entity.velocity)


func get_transition():
	# If no direction input, go back to idle
	if entity.input_direction == Vector2.ZERO:
		return "idle"
	return null

func handle_input(event):
	if "fly" in entity.capabilities:
		if event.is_action_pressed("friend_ability"):
			return "fly"
		return null
