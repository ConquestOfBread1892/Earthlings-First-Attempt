class_name PlayerIdleState extends BaseState

func _init(player):
	super._init(player)

func enter():
	# Reset velocity when entering idle state
	entity.velocity = Vector2.ZERO
	
	# Animation will be handled via the get_current_state_name() method

func update(delta):
	# No specific behavior needed for idle state
	pass

func get_transition():
	# If player has direction input, transition to walk state
	if entity.normalized_velocity != Vector2.ZERO:
		return "walk"
	return null

func handle_input(event):
	# Handle specific input that might change state
	# Example: If this was ChickenPlayer and fly button was pressed
	if event.is_action_pressed("form_ability"):
		if "fly" in entity.capabilities:
			return "fly"
	return null
