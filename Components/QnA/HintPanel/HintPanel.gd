extends Node

onready var hint = $VBoxContainer/Hint

func _setHint(value):
	hint.text = value
