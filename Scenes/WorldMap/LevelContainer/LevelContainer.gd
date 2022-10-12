extends Area2D

onready var tensSprites = $Tens
onready var onesSprites = $Ones

export(PackedScene) var targetLevel setget , _getTargetLevel
export(int, 0, 9) var tens
export(int, 0, 9) var ones

var onTop: bool = false

func _ready():
	onesSprites.frame = ones
	tensSprites.frame = tens

func _on_LevelContainer_body_entered(body):
	if body.name == "LevelSelector" and get_overlapping_bodies().size() > 0:
		body._setLevel(targetLevel)

func _getTargetLevel():
	return targetLevel
