class_name PlayerWalkState extends BaseState

func _init(player):
	super._init(player)

func enter():
	# No specific enter behavior needed
	pass

func update(delta):
	# Calculate velocity based on direction and speed
	entity.velocity = entity.normalized_velocity * entity.get_speed() * delta

func get_transition():
	# If no direction input, go back to idle
	if entity.normalized_velocity == Vector2.ZERO:
		return "idle"
	return null

func handle_input(event):
	if "fly" in entity.capabilities:
		if event.is_action_pressed("form_ability"):
			return "fly"
		return null
