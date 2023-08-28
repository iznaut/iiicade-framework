class_name Joystick

# convenience mappings for inputs
enum {
	UP = JOY_DPAD_UP
	DOWN = JOY_DPAD_DOWN
	LEFT = JOY_DPAD_LEFT
	RIGHT = JOY_DPAD_RIGHT
	BTN_PRIMARY = JOY_BUTTON_0
	BTN_SECONDARY = JOY_BUTTON_1
	BTN_START = JOY_BUTTON_11
}

# convenience mappings for player indexes
enum {
	P1,
	P2,
	P3,
	P4
}

const debug_keymap = {
	UP: "ui_up",
	DOWN: "ui_down",
	LEFT: "ui_left",
	RIGHT: "ui_right",
	BTN_PRIMARY: "ui_accept",
	BTN_SECONDARY: "ui_cancel",
	BTN_START: "ui_select"
}


static func is_pressed(input, player_index) -> bool:
	var is_valid = Input.is_joy_button_pressed(player_index, input) or (
		# if debug mode enabled, allow keyboard input
		Input.is_action_pressed(debug_keymap[input])
		and player_index == DebugOverlay.keyboard_player_index
		and DebugOverlay.visible
	)

	if is_valid:
		Manager.emit_signal("joystick_input_handled", input, player_index)

	return is_valid


static func is_any_pressed(player_index) -> bool:
	var input_list = debug_keymap.keys()

	for input in input_list:
		if is_pressed(input, player_index):
			return true

	return false
