class_name PlayerFriendManagerUi extends CanvasLayer
@onready var input_manager: InputManager = $"../../InputManager"

@onready var color_rect: ColorRect = get_child(0)

var last_func


func _ready():
	signals_connect()
	to_green()


func signals_connect():
	GameEvents.input_manager_form_or_friend_toggle.connect(_toggle_color)
	
#green is player manager
func to_green():
	last_func = "to_green"
	color_rect.color = Color(0,1,0,1)

#blue is friend mangaer
func to_blue():
	last_func = "to_blue"
	color_rect.color = Color(0,0,1,1)

func _toggle_color():
	if last_func == "to_blue":
		to_green()
	else: #elif last_func == "to_green":
		to_blue()
