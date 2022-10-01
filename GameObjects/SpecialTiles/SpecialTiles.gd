extends Area2D
class_name SpecialTile

func _ready():
	self.connect("area_entered", self, "_onAreaPlayerEntered")
