class_name ChickenPlayer extends BasePlayer

@onready var player_friend_manager: Node = get_parent().get_parent()
@onready var player_manager: Node = get_parent()


func _ready() -> void:
	super._ready()

	capabilities = ["fly"]
	# Add fly state specific to chicken - THIS MUST HAPPEN AFTER super._ready()
	state_machine.add_state("fly", PlayerFlyState.new(self))


func get_speed() -> int:
	return 3000

func get_form_name() -> String:
	return "chicken"
