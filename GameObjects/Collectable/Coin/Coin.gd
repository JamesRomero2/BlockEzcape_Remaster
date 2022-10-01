extends Collectable

signal CoinCollected

onready var sprite = $Sprite
onready var animation = $AnimationPlayer

var collected: bool = false

func _onAreaEntered(area: Area2D):
	if area.name == "PlayerEffectArea" and !collected:
		collected = true
		emit_signal("CoinCollected")
		animation.play("CoinCollected")
#		Add Method that will Increase the Player's Coin
