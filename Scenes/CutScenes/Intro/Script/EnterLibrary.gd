extends Area2D

func _input(event):
	if event.is_action_pressed("space"):
		if get_overlapping_bodies().size() > 0:
			LoadingScreen.loadLevel("LibraryCutScene")
