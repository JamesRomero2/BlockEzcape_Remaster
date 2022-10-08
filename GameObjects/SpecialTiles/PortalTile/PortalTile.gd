extends SpecialTile

export var partnerID: int

var teleportationInProgress: bool = false
var teleportLocation: Vector2 = Vector2.ZERO
var teleportationEnable: bool = true

func _ready():
	var teleportPadGroup = get_tree().get_nodes_in_group("TeleportPad")
	if teleportPadGroup.size() < 1: return

	for teleportPad in teleportPadGroup:
		if self.name != teleportPad.name:
			if partnerID == teleportPad.partnerID:
				teleportLocation = teleportPad.position

func _onAreaPlayerEntered(area: Area2D):
	if !teleportationEnable: return
	if area.name == "PlayerEffectArea" and !teleportationInProgress:
		var playerObject = area.get_parent()
		playerObject.position = teleportLocation
		teleportationInProgress = true
		yield(get_tree().create_timer(0.3), "timeout")
		teleportationInProgress = false
