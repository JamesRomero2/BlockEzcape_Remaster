extends Area2D

export var partnerID: int

onready var landing := $LandingPosition

var teleportationInProgress: bool = false
var teleportLocation: Vector2 = Vector2.ZERO
var teleportationEnable: bool = true

func _ready():
	var teleportPadGroup = get_tree().get_nodes_in_group("TeleportPad")
	for teleportPad in teleportPadGroup:
		if partnerID == teleportPad.partnerID:
			teleportLocation = teleportPad.landing.position
#	teleportLocation = targetPos.position

func _on_Teleporter_body_entered(body):
	if body.name == "LevelSelector":
		body.position = teleportLocation
