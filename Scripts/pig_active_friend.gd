class_name PigActiveFriend extends BaseActiveFriend


func _ready():
	super._ready()
	print(self, "collision_layer: ", collision_layer, "collision_mask: ", collision_mask)
	

func get_friend_name():
	return "pig"


func get_speed():
	return 7000
