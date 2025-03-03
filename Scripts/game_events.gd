#singleton
#class_name GameEvents
extends Node




#InputManager

#Player Movement
signal input_manager_player_movement_input(direction_param)

#Friend Movement
signal input_manager_friend_movement_input(direction_param)
#Form Or Friend Toggle
signal input_manager_form_or_friend_toggle()
#Form Or Friend Selecting
signal input_manager_form_or_friend_next_or_prev(next_or_prev)
#Friend Ability
signal input_manager_friend_ability_just_pressed()
signal input_manager_friend_ability_just_released()
#Form Ability
signal input_manager_form_ability_just_pressed()
signal input_manager_form_ability_just_released()


#PlayerFriendManager
signal player_friend_manager_active_friend_change(active_friend_param)
signal player_friend_manager_form_next_or_prev(next_or_prev)
signal player_friend_manager_friend_next_or_prev(next_or_prev)

#PlayerManager
signal player_manager_current_form_change(current_form_param)
signal player_manager_on_form_next_or_prev()
signal player_manager_form_next()
signal player_manager_form_prev()

#FriendManager
signal friend_manager_active_friend_change(active_friend_param)
