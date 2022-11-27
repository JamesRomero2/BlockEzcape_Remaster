extends Area2D

export(String) var timeLine

var dialogPlaying := true

func _input(event):
	if GameManager._getGamePause():
		if event.is_action_pressed("space") and dialogPlaying:
			if get_overlapping_bodies().size() > 0:
				if get_node_or_null('DialogNode') == null:
					dialogPlaying = false
					GameManager._setGamePaused(true)
					var dialog = Dialogic.start(timeLine)
					dialog.connect('timeline_end', self, 'dialogEnd')
					add_child(dialog)

func dialogEnd(timeline_name):
	GameManager._setGamePaused(false)
	dialogPlaying = true
