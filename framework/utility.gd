class_name Utility


# returns true/false for the given player
static func is_player_active(player_index: int) -> bool:
	return Manager.joystick_state_data[player_index].active


# returns the corresponding code for the last input detected
# player_index is optional! if not specified, this will return the last code from ANY player
static func get_last_input(player_index : int = -1) -> int:
	var joystick_state_data = Manager.joystick_state_data

	if player_index == -1:
		var timestamps = []

		for state_data in joystick_state_data:
			timestamps.push_back(state_data.last_event_time)
		
		player_index = timestamps.find(timestamps.max())

	var state_data = joystick_state_data[player_index]

	return state_data.last_input


# returns "P1" from index 0, "P2" from 1, etc
static func get_player_as_string(player_index) -> String:
	return "P%s" % (player_index + 1) as String