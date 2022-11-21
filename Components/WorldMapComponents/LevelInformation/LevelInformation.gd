extends CanvasLayer

func _showLevelInfo(levelNumber, levelTitle):
	if levelNumber == -1:
		$Control.visible = false
	else:
		$Control.visible = true
		var levelNum = str(levelNumber)
		var record = GameManager._getLevelRecord(levelNumber)
		if record[1] == 0.0:
			$Control/Info/PlaceHolder.visible = true
			$Control/Info/Record.visible = false
		else:
			$Control/Info/PlaceHolder.visible = false
			$Control/Info/Record.visible = true
			$Control/Info/Record/HBoxContainer/LevelTitle3.text = record[0]
			$Control/Info/Record/VBoxContainer/LevelTitle4.text = record[3]
		
		if levelNumber < 10:
			$Control/VBoxContainer/LevelNumber.text = "Level 0" + str(levelNumber)
		else:
			$Control/VBoxContainer/LevelNumber.text = "Level " + str(levelNumber)
		$Control/VBoxContainer/LevelTitle.text = levelTitle
