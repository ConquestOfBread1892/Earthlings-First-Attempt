class_name BaseActiveFriend extends CharacterBody2D



@onready var active_friend_animation_controller: ActiveFriendAnimationController = $ActiveFriendAnimator




var friend_name = get_friend_name()
var input_direction: Vector2 


# State machine 
var state_machine: StateMachine

var capabilities: Array = []

func _ready():
	#print(friend_name, "  BaseActiveFriend- collision_layer: ", collision_layer, "  collision_mask: ", collision_mask)
	signals_connect()
	initialize_state_machine()

func signals_connect():
	GameEvents.input_manager_friend_movement_input.connect(_on_input_manager_friend_movement_input)

func initialize_state_machine():
	# Create the state machine
	state_machine = StateMachine.new(self)
	
	# Add base states
	state_machine.add_state("idle", ActiveFriendIdleState.new(self))
	state_machine.add_state("walk", ActiveFriendWalkState.new(self))
	
	# Initialize with idle state
	state_machine.change_state("idle")
	
	# Add child so it processes with the friend
	add_child(state_machine)


func _physics_process(delta: float) -> void:
	# Let the state machine handle state-specific behavior
	state_machine.update(delta)
	move_and_slide()

func _input(event: InputEvent) -> void:
	# Pass input to the state machine
	state_machine.handle_input(event)

func _on_input_manager_friend_movement_input(input_direction_param):
	input_direction = input_direction_param

func get_friend_name():
	return "base_active_friend"

func get_speed() -> int:
	return 5000

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
