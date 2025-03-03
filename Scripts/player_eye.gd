class_name PlayerEye extends AnimatedSprite2D

@onready var base_player: BasePlayer = $".."

@onready var player_eye: PlayerEye = $"."

@onready var player_animation_controller: AnimatedSprite2D = get_parent().get_node("PlayerAnimationController")

@onready var base_z_index = z_index
var base_x_pos = position.x
var base_y_pos = position.y



var current_tween: Tween


func hide_eye():
	visible = false
	
func show_eye():
	visible = true

#called by PlayerAnimationController 
func set_eye(form_name_param: String, direction_param: String):
		if direction_param == "left":

			if form_name_param == "cow":
				position.x = base_x_pos - 7	
				position.y = base_y_pos - 2

			elif form_name_param == "pig":
				position.x = base_x_pos - 3
				position.y = base_y_pos - 2

			elif form_name_param == "chicken":
				position.x = base_x_pos - 3
				position.y = base_y_pos - 3


		elif direction_param == "right":
			
			if form_name_param == "cow":
				position.x = base_x_pos + 7
				position.y = base_y_pos - 2

			elif form_name_param == "pig":
				position.x = base_x_pos + 3
				position.y = base_y_pos - 2

			elif form_name_param == "chicken":
				position.x = base_x_pos + 3
				position.y = base_y_pos - 3

#call in PlayerAnimationController when idle
func alien_eye_to_idle():
	position.y = base_y_pos - 5
	

#call in PlayerAnimationController when idle left
func eye_to_left_idle(form_name_param: String):
	if form_name_param == "cow":
		position.x = base_x_pos - 7
		position.y = base_y_pos - 2
		
	elif form_name_param == "pig":
		position.x = base_x_pos - 3
		position.y = base_y_pos - 2
		
	elif form_name_param == "chicken":
		position.x = base_x_pos - 3
		position.y = base_y_pos - 3

#call in PlayerAnimationController when idle right
func eye_to_right_idle(form_name_param: String):
	if form_name_param == "cow":
		position.x = base_x_pos + 7
		position.y = base_y_pos - 2
		
	elif form_name_param == "pig":
		position.x = base_x_pos + 3
		position.y = base_y_pos - 2

	elif form_name_param == "chicken":
		position.x = base_x_pos + 3
		position.y = base_y_pos - 3

	
#call in PlayerAnimationController when walk left
func eye_to_left_walk(form_name_param: String):
	if form_name_param == "cow":
		position.x = base_x_pos - 7

	elif form_name_param == "pig":
		position.x = base_x_pos - 3

	elif form_name_param == "chicken":
		position.x = base_x_pos - 3


#call in PlayerAnimationController when walk right
func eye_to_right_walk(form_name_param: String):
	if form_name_param == "cow":
		position.x = base_x_pos + 7

	elif form_name_param == "pig":
		position.x = base_x_pos + 3
		
	elif form_name_param == "chicken":
		position.x = base_x_pos + 3
		
		
#call in PlayerAnimationController when fly right
func eye_to_right_fly(form_name_param: String):
	if form_name_param == "chicken":
		position.x = base_x_pos + 3
		
#call in PlayerAnimationController when fly left
func eye_to_left_fly(form_name_param: String):	
	if form_name_param == "chicken":
		position.x = base_x_pos - 3
		




#call in PlayerAnimationController in the func _on_frame_changed() (should be PlayerAnimationController connected to its own _on_frame_changed signal)
func eye_walk_bounce(form_name_param: String, frame: int):
	if form_name_param == "alien":
		if frame % 2 == 0:
			position.y = base_y_pos -5
		elif frame % 1 == 0:
			position.y = base_y_pos -4
		
	elif form_name_param == "cow":
		if frame % 2 == 0:
			position.y = base_y_pos -2
		elif frame % 1 == 0:
			position.y = base_y_pos -1
	
	elif form_name_param == "pig":
		if frame % 2 == 0:
			position.y = base_y_pos -2
		elif frame % 1 == 0:
			position.y = base_y_pos -3
			
	elif form_name_param == "chicken":
		if frame % 2 == 0:
			position.y = base_y_pos -3
		elif frame % 1 == 0:
			position.y = base_y_pos -2



#called in PlayerAnimationController _physics_process
#(I think there is a way to only call it if something is moving which sounds like the relevent 
#time to call it since the eye wont move if nothing is moving)
func eye_tracking(current_friend: BaseActiveFriend):
	if not current_friend or not visible:
		return
	
	var eye_pos = global_position
	var friend_pos = current_friend.global_position

	var diff_x = friend_pos.x - eye_pos.x  #if friend.x is 2 and eye.x is 3 then 2 - 3 is -1. because the .x is negative it means its on the left
	var diff_y = friend_pos.y - eye_pos.y  #if friend.y is 3 and eye.y is 2 then 3 - 2 is 1. because the .y is positive it means its on the down

	var eye_tracking_direction    # holds the direction to concatenate later to play the correct animation for the eyes direction
	
	if diff_y < 0:
		if diff_x < 0:
			eye_tracking_direction = "up_left"    # Top-left corner
		else:
			eye_tracking_direction = "up_right"   # Top-right corner
	else:
		if diff_x < 0:
			eye_tracking_direction = "down_left"    # Top-left corner
		else:
			eye_tracking_direction = "down_right"   # Top-right corner
			
			
	play("top_eye_" + eye_tracking_direction)





func lift_off_tween():
	kill_then_new_tween()
	current_tween.tween_property(self, "position:y", (base_y_pos -7), 0.2)
	
#adjusts the sprite down for landing
func landing_tween():
	kill_then_new_tween()
	current_tween.tween_property(self, "position:y", (base_y_pos -3), 0.1)
	
#ends existing tween and replaces it with a blank
func kill_then_new_tween():
	if current_tween:
		current_tween.kill() #stop any existing tween
	current_tween = create_tween()
	
	
