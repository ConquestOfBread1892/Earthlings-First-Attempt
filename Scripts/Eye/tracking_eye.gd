class_name TrackingEye extends AnimatedSprite2D

@onready var main = get_tree().get_root().find_child("Main", true, false)
var active_friend: BaseActiveFriend
var current_form: BasePlayer
enum GazeTarget {PLAYER, ACTIVEFRIEND}
@export_enum("Player", "ActiveFriend") var gaze_target: int = GazeTarget.ACTIVEFRIEND
var target: Node

func _ready() -> void:
	# Wait for one frame to ensure the initial scene is loaded
	await get_tree().process_frame
	
	# Connect to the signal directly from GameEvents
	GameEvents.player_friend_manager_active_friend_change.connect(_on_player_friend_manager_active_friend_change)
	GameEvents.player_manager_current_form_change.connect(_on_player_manager_current_form_change)
	
	# Get initial active friend 
	var friend_manager = get_tree().get_root().find_child("FriendManager", true, false)
	if friend_manager:
		# Try to get the initial active friend directly from the FriendManager
		active_friend = friend_manager.active_friend
	
	var player_manager = get_tree().get_root().find_child("PlayerManager", true, false)
	if player_manager:
		current_form = player_manager.current_form
	
	_update_target()
		
		
		
	if not active_friend:
		push_error("Missing required nodes for active friend eye tracking")
		return
	else:
		print("TrackingEye: Initial active_friend found:", active_friend)

func _on_player_friend_manager_active_friend_change(active_friend_param):
	active_friend = active_friend_param
	_update_target()
	#print("TrackingEye: active_friend changed to:", active_friend)
	
func _on_player_manager_current_form_change(current_form_param):
	current_form = current_form_param
	_update_target()

func _update_target():
	match gaze_target:
		GazeTarget.PLAYER:
			target = current_form
		GazeTarget.ACTIVEFRIEND:
			target = active_friend


func _physics_process(delta: float) -> void:
	# Only check for the target we actually need
	if (gaze_target == GazeTarget.PLAYER && current_form) || (gaze_target == GazeTarget.ACTIVEFRIEND && active_friend):
		eye_tracking()

func eye_tracking():
	if not visible or not target:
		return
	
	var eye_pos = global_position
	var target_pos = target.global_position

	var diff_x = target_pos.x - eye_pos.x  #if target.x is 2 and eye.x is 3 then 2 - 3 is -1. because the .x is negative it means its on the left
	var diff_y = target_pos.y - eye_pos.y  #if target.y is 3 and eye.y is 2 then 3 - 2 is 1. because the .y is positive it means its on the down

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
