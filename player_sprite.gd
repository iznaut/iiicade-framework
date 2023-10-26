extends Node2D


# "export" variables can be set per instance of an object
# each sprite should have a different player_index set in editor
@export var player_index = 0


# this function is run when the player sprite is created
func _ready():
	# this tells the Manager to call us when a player is activated or deactivated (due to idling for too long)
	Manager.connect("player_activated", Callable(self, "_on_player_activated"))
	Manager.connect("player_idled", Callable(self, "_on_player_idled"))


# this function runs every "tick"
func _process(_delta):
	# when a direction is pressed, move player sprite
	if Joystick.is_pressed(Joystick.UP, player_index):
		position.y -= 1
	if Joystick.is_pressed(Joystick.DOWN, player_index):
		position.y += 1
	if Joystick.is_pressed(Joystick.LEFT, player_index):
		position.x -= 1
	if Joystick.is_pressed(Joystick.RIGHT, player_index):
		position.x += 1

	# when a button is pressed, rotate player sprite
	if Joystick.is_pressed(Joystick.BTN_PRIMARY, player_index):
		rotation_degrees -= 1
	if Joystick.is_pressed(Joystick.BTN_SECONDARY, player_index):
		rotation_degrees += 1
	
	# if any button is pressed and not already active, activate this player
	if Joystick.is_any_pressed(player_index) and not Utility.is_player_active(player_index):
		Manager.emit_signal("player_activated", player_index)


# what happens when a player has joined the game?
func _on_player_activated(activated_player_index):
	# all players will recieve this signal - make sure we're affecting the right one
	if activated_player_index == player_index:
		show() # make the player sprite visible


# what happens when a player has been idle for too long?
func _on_player_idled(idle_player_index):
	# all players will recieve this signal - make sure we're affecting the right one
	if idle_player_index == player_index:
		hide() # make the player sprite invisible
