class_name BasePlayer extends CharacterBody2D

@onready var player_animation_controller: PlayerAnimationController = $PlayerAnimationController
@onready var player_eye: PlayerEye = $PlayerEye


var form_name: String = get_form_name()
var normalized_velocity: Vector2
# State machine instance
var state_machine: StateMachine

var capabilities: Array = []

func _ready():
	#print(form_name, "  BasePlayer- collision_layer: ", collision_layer, "  collision_mask: ", collision_mask)
	base_player_signals_connect()
	initialize_state_machine()
	


func base_player_signals_connect():
	GameEvents.input_manager_player_movement_input.connect(_on_input_manager_player_movement_input)
	

func initialize_state_machine():
	#Create the state machine
	state_machine = StateMachine.new(self)
	
	#Add states
	state_machine.add_state("idle", PlayerIdleState.new(self))
	state_machine.add_state("walk", PlayerWalkState.new(self))

	#initialize with idle state
	state_machine.change_state("idle")
	
	# Add child so it processes with the player
	add_child(state_machine)

func _physics_process(delta: float) -> void:
	state_machine.update(delta)
	move_and_slide()
	
	
func _input(event: InputEvent) -> void:
		# Pass input to the state machine
	state_machine.handle_input(event)

	
#calculates the velocity
func apply_base_velocity(delta):
	velocity = normalized_velocity * get_speed() * delta

func _on_input_manager_player_movement_input(input_direction_param):
	normalized_velocity = input_direction_param



func get_speed() -> int:
	return 5000

func get_form_name() -> String:
	return "base_player"
	
func get_capabilities() -> Array:
	return capabilities
	
	
# Public method to get the current state name (useful for animation controller)
func get_current_state_name() -> String:
	if state_machine and state_machine.current_state:
		# Find the state name from the states dictionary
		for state_name in state_machine.states:
			if state_machine.states[state_name] == state_machine.current_state:
				return state_name
	return "idle" # Default fallback
