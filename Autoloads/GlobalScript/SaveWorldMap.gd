extends Node

const SAVEFILE = "user://player_worldmap.save"
var worldData = {}

func _ready():
	_loadSettings()

func _saveSettings():
	var file = File.new()
	file.open(SAVEFILE, File.WRITE)
	file.store_var(worldData)
	file.close()

func _loadSettings():
	var file = File.new()
	if not file.file_exists(SAVEFILE):
		worldData = {
			"worldSelectorPosition": {
				"x": -400,
				"y": -312,
			},
			"levelsOpen": [00],
		}
		_saveSettings()
	file.open(SAVEFILE, File.READ)
	worldData = file.get_var()
	file.close()

