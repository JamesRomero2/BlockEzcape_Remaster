extends Area2D

var libraryScene = "res://Scenes/CutScenes/LibraryCutscene/LibraryCutscene.tscn"

func _input(event):
	if event.is_action_pressed("space"):
		if get_overlapping_bodies().size() > 0:
			SceneTransition._changeScene(libraryScene)
