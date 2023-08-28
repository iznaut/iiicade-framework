extends Sprite


func _input(event):
	if event is InputEventMouseMotion:
		position += event.speed / 100
