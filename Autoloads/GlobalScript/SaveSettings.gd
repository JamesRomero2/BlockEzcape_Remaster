extends Node

const SAVEFILE = "user://player_settings.save"
var settingsData = {}

func _ready():
	_loadSettings()

func _saveSettings():
	var file = File.new()
	file.open(SAVEFILE, File.WRITE)
	file.store_var(settingsData)
	file.close()

func _loadSettings():
	var file = File.new()
	if not file.file_exists(SAVEFILE):
		settingsData = {
			"fullScreen": true,
			"musicVolume": 0.5,
			"sfxVolume": 0.5
		}
		_saveSettings()
	file.open(SAVEFILE, File.READ)
	settingsData = file.get_var()
	file.close()
