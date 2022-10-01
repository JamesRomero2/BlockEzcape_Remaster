extends Collectable

signal KeyCollected

onready var animation: AnimationPlayer = $AnimationPlayer

var collected: bool = false

func _onAreaEntered(area: Area2D):
	if area.name == "PlayerEffectArea" and !collected:
		collected = true
		emit_signal("KeyCollected")
		$AnimationPlayer.play("KeyCollected")
