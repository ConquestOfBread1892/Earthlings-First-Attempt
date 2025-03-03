class_name AlienPlayer extends BasePlayer


func _ready():
	super._ready()
	print(self, "collision_layer: ", collision_layer, "collision_mask: ", collision_mask)
	
func get_form_name() -> String:
	return "alien"
