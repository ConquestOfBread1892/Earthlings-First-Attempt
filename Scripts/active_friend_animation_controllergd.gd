class_name ActiveFriendAnimationController extends AnimatedSprite2D

@onready var active_friend = get_parent()

var direction = "left"

var current_tween: Tween

var base_z_index = z_index
var base_y = position.y
var fly_y = base_y - 4
	



func play_lift_off_tween():
		lift_off_tween()
		
func play_landing_tween():
		landing_tween()


#Animations
func play_idle_animation() -> void:
	left_or_right(direction)
	play("idle_left")

func play_walk_animation(velocity: Vector2) -> void:
	vector_to_direction(velocity)
	play("walk_left")
	
func play_fly_animation(velocity: Vector2) -> void:
	vector_to_direction(velocity)
	play("fly_left")



func vector_to_direction(velocity: Vector2):
	if velocity != Vector2.ZERO:
		if abs(velocity.x) > abs(velocity.y):
			direction = "left" if velocity.x < 0 else "right"
			
		left_or_right(direction)

func left_or_right(direction_param):
	if direction == "left":
		flip_h = false
	elif direction == "right":
		flip_h = true

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
