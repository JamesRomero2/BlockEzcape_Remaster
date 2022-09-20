extends VBoxContainer

#signal playerSelects
#
#var answer = "" setget _setAnswer, _getAnswer
#
#func _ready():
#	for i in get_children():
#		i.connect("pressed", self, "_onButtonPressed", [i])
#
#func _onButtonPressed(button):
#	_setAnswer(button.get_child(0).get_child(0).get_child(1).text)
#	emit_signal("playerSelects")
#
#func _setAnswer(value):
#	answer = value
#
#func _getAnswer():
#	return answer
