class_name StateMachine extends Node

var current_state: BaseState
var states = {}
var entity  # The entity this state machine controls

func _init(entity_param):
	#assigns this state machine to an entity
	entity = entity_param
	
#used to decide which states we want to add. Called in the characters func _ready 
func add_state(state_name, state_instance):
	states[state_name] = state_instance

#called by the StateMachines func update when the criteria for a state change has been met
func change_state(new_state_name):
	
	# Check if the state exists first
	if not states.has(new_state_name):
		print("Entity: ", entity, "  State '", new_state_name, "' doesn't exist for this entity!")
		return
	#if we are in a state
	if current_state:
		#do the closing duties for the state
		current_state.exit()
	
	#print("Changing from ", "no state" if current_state == null else "current state", " to ", new_state_name)
	#change current_state to the new_state_name param
	current_state = states[new_state_name]
	#do the opening duties for the state(Like set velocity to zero if its idle)
	current_state.enter()

#called in the _physics_process (checks for things like s	tate changes and calls the character func update (chich controls the movement)
func update(delta):
	#if there is a current_state
	if current_state:
		#then do that states update function
		current_state.update(delta)
		
		
		# Deliberate ordering of transition checks to have input happen first
		var input_transition = current_state.get_input_requested_transition()
		if input_transition:
			change_state(input_transition)

		else:
			# Check for state transitions
			var new_state = current_state.get_transition()
			#if new_state does not return null (new_state will return null if no criteria for a state change is met)
			if new_state:
				#exits() the current state and enters the new_state (also sets new state as current state)
				change_state(new_state)

#called in the charactes func _input to handle the input using the code in the provided State script
func handle_input(event):
	#if we are in a state
	if current_state:
		
		#
		var new_state = current_state.handle_input(event)
		if new_state:
			change_state(new_state)
