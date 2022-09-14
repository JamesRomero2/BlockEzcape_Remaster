extends Area2D

signal CoinCollected

var collected: bool = false

func _on_Coin_body_entered(body):
	if body.name == "Player" and !collected:
		emit_signal("CoinCollected")
#		Add Method that will Increase the Player's Coin
		queue_free()
