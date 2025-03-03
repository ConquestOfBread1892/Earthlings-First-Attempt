class_name PlayerFriendManager extends Node



@onready var input_manager: Node = $"../InputManager"

@onready var player_friend_manager_ui: CanvasLayer = $PlayerFriendManagerUI

@onready var friend_manager: Node = $FriendManager
@onready var passive_friend_manager: Node = $FriendManager/PassiveFriendManager
@onready var active_friend_manager: Node = $FriendManager/ActiveFriendManager

@onready var player_manager: Node = $PlayerManager



var form_or_friend = "form"

func _ready():
	signals_connect()

func signals_connect():
	GameEvents.input_manager_form_or_friend_toggle.connect(_on_form_or_friend_toggle)
	GameEvents.input_manager_form_or_friend_next_or_prev.connect(_on_form_or_friend_next_or_prev)

	GameEvents.friend_manager_active_friend_change.connect(_on_friend_manager_active_friend_change)


func _on_form_or_friend_next_or_prev(next_or_prev: String):
	if form_or_friend == "form":
		GameEvents.player_friend_manager_form_next_or_prev.emit(next_or_prev)

	elif form_or_friend == "friend":
		GameEvents.player_friend_manager_friend_next_or_prev.emit(next_or_prev)


#updates the current_forms.current_friend
func _on_friend_manager_active_friend_change(active_friend_param: BaseActiveFriend):
	player_manager.current_form.player_animation_controller.active_friend = active_friend_param
	GameEvents.player_friend_manager_active_friend_change.emit(active_friend_param)
	
func _on_form_or_friend_toggle():
	if form_or_friend == "form":
		form_or_friend = "friend"
	else: #elif form_or_friend_selector == "friend":
		form_or_friend = "form"
