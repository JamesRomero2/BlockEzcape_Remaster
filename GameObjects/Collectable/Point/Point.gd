extends Collectable

signal PointCollected

onready var animation = $AnimationPlayer

var collected: bool = false

func _onAreaEntered(area: Area2D):
	if area.name == "PlayerEffectArea" and !collected:
		collected = true
		emit_signal("PointCollected")
		animation.play("PointCollected")
