class_name ActiveFriendIdleState extends BaseState

func _init(friend):
	super._init(friend)

func enter():
	# Reset velocity when entering idle state
	entity.velocity = Vector2.ZERO
	
	# Play idle animation
	entity.active_friend_animation_controller.play_idle_animation()

func update(delta):
	# No specific behavior needed for idle state
	pass

func get_transition():
	# If friend has direction input, transition to walk state
	if entity.input_direction != Vector2.ZERO:
		return "walk"
	return null

func handle_input(event):
	if "fly" in entity.capabilities:
		if event.is_action_pressed("friend_ability"):
			return "fly"
		return null
