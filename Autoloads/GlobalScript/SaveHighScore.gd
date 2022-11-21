extends Node

const SAVEFILE = "user://player_high_score.save"
var highScoreData = {}

func _ready():
	_loadHighScore()

func _saveHighScore():
	var file = File.new()
	file.open(SAVEFILE, File.WRITE)
	file.store_var(highScoreData)
	file.close()
	
func _loadHighScore():
	var file = File.new()
	if not file.file_exists(SAVEFILE):
		highScoreData = {
			"0": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"1": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"2": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"3": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"4": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"5": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"6": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"7": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"8": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"9": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"10": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"11": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"12": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"13": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"14": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"15": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"16": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"17": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"18": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"19": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
			"20": {
				"Time": {
					"InterpretedTime": "No Record Yet",
					"Minutes": 0.0,
					"Seconds": 0.0
				},
				"Ranking": "No Record Yet",
				"Steps": "No Record Yet"
			},
		}
		_saveHighScore()
	file.open(SAVEFILE, File.READ)
	highScoreData = file.get_var()
	file.close()
