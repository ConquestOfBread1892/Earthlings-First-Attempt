class_name BaseState extends Node

# Define layers for clarity
const PLAYER_LAYER = 1
const ACTIVE_FRIEND_LAYER = 4
const PASSIVE_FRIEND_LAYER = 7
const WORLD_OBJECT_LAYER = 10
const FLYING_LAYER = 28
const HEIGHT3_LAYER = 29 
const HEIGHT2_LAYER= 30
const HEIGHT1_LAYER = 31 
const HEIGHT0_LAYER = 32


var entity


func _init(entity_param):
	entity = entity_param
	
func enter():
	#called when entering this state
	pass
	
func exit():
	#called when exiting this state
	pass
	
func update(delta):
	# Called during _process or _physics_process
	pass
	
	# Handle input and potentially trigger state transitions with get_input_requested_transition()
func handle_input(event):
	
	pass



func get_input_requested_transition():
	return null


func get_transition():
	#Return the next state if a transition should happen, otherwise return null
	#(important because then i can try and assign get_transition() to a var and if its not time to transition the var will return null
	#(so something like "if var:" would check if its time to swap))
	return null
