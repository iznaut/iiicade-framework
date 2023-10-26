extends Node


# signals allow communication between scripts
# other Nodes can "listen" for these signals and react accordingly
signal player_activated(player_index)
signal player_idled(player_index)
signal joystick_input_handled(input, player_index)


# caches various state data for each joystick
# can be queried directly or via utility functions (like "is_player_active")
var joystick_state_data : Array = []


# initialize the state data array
# and start listening to the idle timers
func _ready() -> void:
	joystick_state_data.resize(4)
	joystick_state_data.fill({
		"active": false,
		"last_input": null,
		"last_event_time": -1
	})

	var timers = get_children()

	for i in range(timers.size()):
		timers[i].connect("timeout", Callable(self, "_on_player_timeout").bind(i))
	
	# also hide the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(_delta) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


# when the "joystick_input_handled" signal is emitted, update state data
# and restart the idle timer for that player
func _on_Manager_joystick_input_handled(input : int, player_index : int) -> void:
	if joystick_state_data[player_index].active:
		joystick_state_data[player_index].last_input = input
		joystick_state_data[player_index].last_event_time = Time.get_ticks_msec()

		var timer : Timer = get_node("Timeout%s" % Utility.get_player_as_string(player_index))
		timer.start()


# when the "player_activated" signal is emitted, set active state to "true"
func _on_player_activated(player_index : int) -> void:
	joystick_state_data[player_index].active = true


# when the "timeout" signal is emitted from a player's timer object, set active state to "false"
# and emit the "player_idled" signal so listeners can react accordingly
func _on_player_timeout(player_index : int) -> void:
	joystick_state_data[player_index].active = false
	emit_signal("player_idled", player_index)
