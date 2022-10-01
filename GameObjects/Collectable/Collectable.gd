extends Area2D
class_name Collectable

func _ready():
	self.connect("area_entered", self, "_onAreaEntered")
