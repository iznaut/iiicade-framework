extends Sprite2D


func _input(event):
	if event is InputEventMouseMotion:
		position += event.velocity / 100
