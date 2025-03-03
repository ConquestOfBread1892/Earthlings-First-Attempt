class_name InputManager extends Node


var player_direction: Vector2 = Vector2.ZERO
var player_direction_string: String = "down"
var friend_direction: Vector2 = Vector2.ZERO


func _process(_delta: float) -> void:
	calculate_and_emit_base_player_velocity()
	
	calculate_and_emit_base_friend_velocity()

func _input(event: InputEvent) -> void:
	#emits signal to toggle form_or_friend selection
	if event.is_action_pressed("form_or_friend_toggle"):
		GameEvents.input_manager_form_or_friend_toggle.emit()
		
	#emits signals to navigate form and friend selection
	if event.is_action_pressed("next"):
		GameEvents.input_manager_form_or_friend_next_or_prev.emit("next")
	if event.is_action_pressed("prev"):
		GameEvents.input_manager_form_or_friend_next_or_prev.emit("prev")
	
	#emits signal to use friend_ability
	if Input.is_action_just_pressed("friend_ability"):
		GameEvents.input_manager_friend_ability_just_pressed.emit()
	elif Input.is_action_just_released("friend_ability"):
		GameEvents.input_manager_friend_ability_just_released.emit()

	#emits signals to start and stop use friend_ability
	if Input.is_action_just_pressed("form_ability"):
		GameEvents.input_manager_form_ability_just_pressed.emit()
	elif Input.is_action_just_released("form_ability"):
		GameEvents.input_manager_form_ability_just_released.emit()
		

func calculate_and_emit_base_player_velocity():
	player_direction = Vector2(
		Input.get_axis("player_left", "player_right"),
		Input.get_axis("player_up", "player_down")
	).normalized()
	#Needed because it returns nil if player_direction == Vector2.ZERO
	if player_direction != Vector2.ZERO:
		player_direction_string = vector2_to_direction(player_direction)
	
	GameEvents.input_manager_player_movement_input.emit(player_direction)
	
func vector2_to_direction(velocity: Vector2):
	var direction_string: String
	if velocity != Vector2.ZERO:
		if abs(velocity.x) > abs(velocity.y):
			direction_string = "left" if velocity.x < 0 else "right"
		else:
			direction_string ="up" if velocity.y < 0 else "down"
		return direction_string
		
			
	
func calculate_and_emit_base_friend_velocity():
	friend_direction = Vector2(
		Input.get_axis("friend_left", "friend_right"),
		Input.get_axis("friend_up", "friend_down")
	).normalized()
	GameEvents.input_manager_friend_movement_input.emit(friend_direction)
