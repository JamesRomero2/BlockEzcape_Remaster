extends Area2D

signal enteredArea(area)

export(String, "Forest", "Underground", "Industrial", "Magical", "Default") var areas

func _on_BG_Changer_body_entered(body):
	if body.name == "LevelSelector":
		emit_signal("enteredArea", areas)


func _on_BG_Changer_body_exited(body):
	if body.name == "LevelSelector":
		emit_signal("enteredArea", "Default")
