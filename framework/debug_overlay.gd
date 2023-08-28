extends Control


var keyboard_player_index : int = Joystick.P1

const debug_start_actions = [
	"debug_start_p1",
	"debug_start_p2",
	"debug_start_p3",
	"debug_start_p4",
]


func _ready():
	# disable and hide this if not playing in editor
	if not OS.has_feature("editor"):
		set_process(false)
		hide()


func _process(_delta):
	for i in range(debug_start_actions.size()):
		if Input.is_action_just_pressed(debug_start_actions[i]):
			var label = $KeyboardInfo/Label
			var prev_player_string = _get_active_keyboard_player_string()

			keyboard_player_index = i
			label.text = label.text.replace(
				prev_player_string,
				_get_active_keyboard_player_string()
			)

	if Input.is_action_just_pressed("toggle_debug_overlay"):
		visible = !visible


func _get_active_keyboard_player_string():
	return Utility.get_player_as_string(keyboard_player_index)
