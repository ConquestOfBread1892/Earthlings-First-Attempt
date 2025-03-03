class_name ActiveFriendManager extends Node


var input_direction: Vector2 = Vector2.ZERO

func set_active_friend(available_friends_param: Array):
	for child in get_children():
		remove_child(child)
	add_child(available_friends_param[0])
	
