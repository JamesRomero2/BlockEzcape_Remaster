extends Area2D

signal enteredArea(area)

export(String, "Forest", "Underground", "Ruins", "Void", "Default") var areas

func _on_BG_Changer_body_entered(body):
	if body.name == "LevelSelector":
		emit_signal("enteredArea", areas)
