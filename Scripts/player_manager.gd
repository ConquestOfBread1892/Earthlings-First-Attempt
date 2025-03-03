class_name PlayerManager extends Node


@onready var player_friend_manager: PlayerFriendManager = get_parent()

@onready var alien_player: BasePlayer = $AlienPlayer 
@onready var pig_player: BasePlayer = $PigPlayer
@onready var chicken_player: BasePlayer = $ChickenPlayer
@onready var cow_player: BasePlayer = $CowPlayer

@onready var available_forms: Array
@onready var number_of_available_forms: int = get_child_count() - 1
@onready var current_form: BasePlayer
@onready var current_form_index: int = 0  # Track the current form's index

var form_or_friend:String = "form"
var input_direction:Vector2 = Vector2.ZERO


func _ready():
	signals_connect()
	setup_forms()
	set_player()


func signals_connect():
	GameEvents.player_friend_manager_form_next_or_prev.connect(_on_player_friend_manager_form_next_or_prev)
	



#done individully to choose the order
func setup_forms():
	available_forms.append(alien_player)
	available_forms.append(pig_player)
	available_forms.append(chicken_player)
	available_forms.append(cow_player)
	current_form = available_forms[current_form_index]
	
	#Dbug print
	#for form in available_forms:
		#print(form)
	#print("Current Form: ", current_form)

#selects the first character in available_forms as the starting form
func set_player():
	for child in get_children():
		remove_child(child)
	add_child(available_forms[0])

func _on_player_friend_manager_form_next_or_prev(next_or_prev: String):
	#heard by: PlayerAnimationController
	GameEvents.player_manager_on_form_next_or_prev.emit()
	
	if next_or_prev == "next":
		GameEvents.player_manager_form_next.emit()
		current_form_index += 1
		if current_form_index > number_of_available_forms:
			current_form_index = 0
	
	elif next_or_prev == "prev":
		GameEvents.player_manager_form_prev.emit()
		current_form_index -= 1
		if current_form_index < 0:
			current_form_index = number_of_available_forms
			
	var next_form = available_forms[current_form_index]
	
	#Dbug Print 
	#print("Next Form: ", next_form, "\n", "Available Forms: ", available_forms, "\n", "Number Of Available Forms: ", number_of_available_forms)
	
	next_form.position = current_form.position
	
	remove_child(current_form)
	add_child(next_form)
	
	current_form = next_form
	GameEvents.player_manager_current_form_change.emit(current_form)
