class_name ChickenActiveFriend extends BaseActiveFriend

@onready var player_friend_manager: Node = get_parent().get_parent().get_parent()

func _ready():
	super._ready()
	capabilities = ["fly"]
	# Add fly state specific to chicken
	state_machine.add_state("fly", ActiveFriendFlyState.new(self))


func get_speed() -> int:
	return 3000
	
func get_friend_name():
	return "chicken"
