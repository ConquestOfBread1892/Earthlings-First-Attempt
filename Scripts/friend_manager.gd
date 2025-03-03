class_name FriendManager extends Node

@onready var player_friend_manager: PlayerFriendManager = $".."

@onready var active_friend_manager: ActiveFriendManager = $ActiveFriendManager
@onready var pig_active_friend: CharacterBody2D = $ActiveFriendManager/PigActiveFriend
@onready var chicken_active_friend: CharacterBody2D = $ActiveFriendManager/ChickenActiveFriend
@onready var cow_active_friend: CharacterBody2D = $ActiveFriendManager/CowActiveFriend


@onready var available_friends: Array
@onready var number_of_available_friends: int = get_node("ActiveFriendManager").get_child_count() - 1
@onready var active_friend: BaseActiveFriend
@onready var active_friend_index: int = 0  # Track the current form's index

func _ready():
	signals_connect()
	setup_available_friends()
	active_friend_manager.set_active_friend(available_friends)


func signals_connect():
	GameEvents.player_friend_manager_friend_next_or_prev.connect(_on_friend_next_or_prev)

func setup_available_friends():
	available_friends.append(pig_active_friend)
	available_friends.append(chicken_active_friend)
	available_friends.append(cow_active_friend)
	active_friend = available_friends[active_friend_index]
	
	
	
func _on_friend_next_or_prev(input_action):
	if input_action == "next":
		active_friend_index += 1
		if active_friend_index > number_of_available_friends:
			active_friend_index = 0

	
	elif input_action == "prev":
		active_friend_index -= 1
		if active_friend_index < 0:
			active_friend_index = number_of_available_friends
			
	var next_active_friend = available_friends[active_friend_index]
	

	next_active_friend.position = active_friend.position
	
	active_friend_manager.remove_child(active_friend)
	active_friend_manager.add_child(next_active_friend)
	
	active_friend = next_active_friend
	#want to change this to a signal that is heard by PlayerFriendManager
	GameEvents.friend_manager_active_friend_change.emit(active_friend)
	
