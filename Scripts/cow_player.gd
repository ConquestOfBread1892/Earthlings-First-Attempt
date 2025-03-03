class_name CowPlayer extends BasePlayer

func _ready():
	super._ready()
	capabilities.append("push")

func get_speed() -> int:
	var speed = 6000
	return speed

func get_form_name() -> String:
	return "cow"
