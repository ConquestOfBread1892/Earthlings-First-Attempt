class_name PlayerAnimationController extends AnimatedSprite2D

@onready var player_friend_manager = get_parent().get_parent().get_parent()


@onready var friend_manager: FriendManager = get_parent().get_parent().get_parent().get_node("FriendManager")
@onready var active_friend: BaseActiveFriend = friend_manager.active_friend

@onready var current_form: BasePlayer = get_parent()
@onready var player_eye: PlayerEye = get_parent().get_node("PlayerEye")

@onready var player_manager: Node = get_parent().get_parent()
@onready var direction: String = "down"
@onready var hor_direction: String = "left"
@onready var alt_2d_forms: Array = ["pig", "chicken", "cow"]

@onready var base_z_index = z_index

var in_air = false
var current_tween: Tween


var base_y = position.y
var fly_y = base_y - 4


func _ready():
	signals_connect()
	
	
func signals_connect():
	GameEvents.player_friend_manager_active_friend_change.connect(_on_player_friend_manager_active_friend_change)
	GameEvents.player_manager_on_form_next_or_prev.connect(_on_player_manager_on_form_next_or_prev)
	GameEvents.input_manager_form_ability_just_pressed.connect(_on_input_manager_form_ability_just_pressed)
	GameEvents.input_manager_form_ability_just_released.connect(_on_input_manager_form_ability_just_released)
	

func _on_input_manager_form_ability_just_pressed():
	if "fly" in current_form.capabilities:
		lift_off_tween()
		player_eye.lift_off_tween()

func _on_input_manager_form_ability_just_released():
	if "fly" in current_form.capabilities:
		landing_tween()
		player_eye.landing_tween()
	
	
func _physics_process(delta: float) -> void:
	if player_eye.visible == true:
		player_eye.eye_tracking(active_friend)
	
	# Get the current state from the state machine
	var current_state = current_form.get_current_state_name()
	
	if current_state == "idle":
		play_idle_animation()
	elif current_state == "walk":
		play_walk_animation(current_form.velocity)
	elif current_state == "fly":
		play_fly_animation(current_form.velocity)


			
##PLAY ANIMATIONS
func play_walk_animation(direction_param: Vector2):
	#establishes direction and hor_direction
	vector2_to_direction(direction_param) 
	
	if current_form.form_name == "alien":
		play("walk_" + direction)
		
	elif current_form.form_name in alt_2d_forms:
		alt_2d_form_animation("walk_")
		
	#if player_eye is found
	if player_eye:
		#shows or hides eye if appropriate
		if current_form.form_name == "alien":
			if direction != "down":
				player_eye.hide_eye()
			else:
				player_eye.show_eye()
				
		#aligns the eye to various forms' walk sprite frames
		else:
			eye_to_walk(current_form.form_name)
				
	
func eye_to_walk(current_form_name_param):
	if hor_direction == "right":
		player_eye.eye_to_right_walk(current_form_name_param)
	elif hor_direction =="left":
		player_eye.eye_to_left_walk(current_form_name_param)

func play_idle_animation():
	if current_form.form_name == "alien":
		player_eye.show_eye()
		player_eye.alien_eye_to_idle()
		play("idle_down")
		
	elif current_form.form_name in alt_2d_forms:
		alt_2d_form_animation("idle_")
	
	
	if player_eye:
		#Cows left and right eye adjustment
		eye_to_idle(current_form.form_name)
				

func eye_to_idle(current_form_name_param):
	if hor_direction == "right":
		player_eye.eye_to_right_idle(current_form_name_param)
	elif hor_direction =="left":
		player_eye.eye_to_left_idle(current_form_name_param)


func play_fly_animation(direction_param: Vector2):
	vector2_to_direction(direction_param)

	if current_form.form_name == "chicken":
		alt_2d_form_animation("fly_")
		
		if hor_direction == "right":
			player_eye.eye_to_right_fly("chicken")
		elif hor_direction =="left":
			player_eye.eye_to_left_fly("chicken")
	
func alt_2d_form_animation(animation_type: String):
	if hor_direction == "right":
		flip_h = true
	elif hor_direction == "left":
		flip_h = false
	play(animation_type + "left")
	
	
##VECTOR TO DIRECTIONS 

#adjust the point where the sprite turns by changing the direction when it crosses the diagnol direction (down/left, up/right)
func vector2_to_direction(velocity: Vector2):
	var previous_direction = direction  # Store the old direction

	if velocity != Vector2.ZERO:
		if abs(velocity.x) > abs(velocity.y):
			direction = "left" if velocity.x < 0 else "right"
		else:
			direction ="up" if velocity.y < 0 else "down"
			
			# Handle the specific transition case
			if direction == "down" and (previous_direction == "left" or previous_direction == "right"):
				# Immediately correct eye position for this specific transition
				if current_form.form_name == "alien":
					player_eye.position.y = player_eye.base_y_pos - 5
				
	vector2_to_hor_direction(velocity)

#adjust the point where the sprite turns by changing left when it crosses the diagnol direction (down/left, up/right)
func vector2_to_hor_direction(velocity: Vector2):
	if current_form.velocity != Vector2.ZERO:
		if current_form.velocity.x < 0:
			hor_direction = "left"
			
		elif current_form.velocity.x > 0:
			hor_direction = "right"

##TWEENS

#adjusts the sprite up for lift off
func lift_off_tween():
	kill_then_new_tween()
	current_tween.tween_property(self, "position:y", fly_y, 0.2)
	
#adjusts the sprite down for landing
func landing_tween():
	kill_then_new_tween()
	current_tween.tween_property(self, "position:y", base_y, 0.1)
	
#ends existing tween and replaces it with a blank
func kill_then_new_tween():
	if current_tween:
		current_tween.kill() #stop any existing tween
	current_tween = create_tween()


func _on_frame_changed() -> void:
	if current_form.form_name == "alien":
		if animation == "walk_down":
			player_eye.eye_walk_bounce(current_form.form_name, frame)
	
	else:
		if "walk" in animation:
			player_eye.eye_walk_bounce(current_form.form_name, frame)
			
func _on_player_friend_manager_active_friend_change(active_friend_param):
	active_friend = active_friend_param

func _on_player_manager_on_form_next_or_prev():
	current_form.player_eye.set_eye(current_form.form_name, hor_direction)
