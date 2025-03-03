extends AnimatedSprite2D

@onready var base_player: BasePlayer = $"../.."
@onready var player_friend_manager: Node = get_parent().get_parent().get_parent().get_parent()
@onready var active_friend: BaseActiveFriend

@onready var body_sprite: AnimatedSprite2D = $".."
@onready var base_y = position.y

var is_eye_rolling = false  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#wait for one frame to happen ensuring the initial scene is loaded
	await get_tree().process_frame
	#then we search for the friend 
	active_friend = player_friend_manager.current_friend
	
	if not active_friend:
		push_error("Missing required nodes for eye tracking")
		return

	animation_finished.connect(_on_animation_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	##?
	show_eye()
	
	##EYE LOCATION
	fix_eye() #Still not sure if this is best called here or in the body_sprite
	
	##EYE TRACKING
	if !is_eye_rolling:
		eye_tracking()


func _on_animation_finished():
	if animation == "top_eye_roll":
		is_eye_rolling = false
		
		
func play_eye_roll_animation():
	is_eye_rolling = true
	play("top_eye_roll")


##EYE LOCATION
#adjusts the eye up or down 1 pixel to match walk animation(called by body_sprite
func adjust_eye(current_form_param, walking_frame: int):
	if current_form_param == "alien":
		if walking_frame % 2 == 1:
			position.y = base_y + 1
			
		if walking_frame % 2 == 0:
			position.y = base_y
		
	
#this resets the eye back to its default position (fixes desyncs)
func fix_eye():
	if base_player.form_name == "alien":
		if body_sprite.animation != "walk_down":
			position.y = base_y
		
		
#determines whether the eye should be shown
func show_eye():
	#approved list of body_sprite animations we want to show the eye in
	if base_player.form_name == "alien":
		var approved = ["walk_down", "idle_down"]
		
		visible = true if body_sprite.animation in approved else false
	
	
##EYE TRACKING
func eye_tracking():
	if not active_friend or not visible:
		return
	
	var eye_pos = global_position
	var active_friend_pos = active_friend.global_position

	var diff_x = active_friend_pos.x - eye_pos.x  #if friend.x is 2 and eye.x is 3 then 2 - 3 is -1. because the .x is negative it means its on the left
	var diff_y = active_friend_pos.y - eye_pos.y  #if friend.y is 3 and eye.y is 2 then 3 - 2 is 1. because the .y is positive it means its on the down

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
