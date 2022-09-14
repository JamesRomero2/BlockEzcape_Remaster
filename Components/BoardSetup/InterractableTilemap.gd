extends TileMap

var NODESCALE: Vector2 =  self.scale
var interactableNodes: Dictionary = {
#	FORMAT
#	TILE INDEX : SCENE ABSOLUTE PATH
	0: preload("res://GameObjects/Entity/Player.tscn"),
	1: preload("res://GameObjects/Interactable/Temple/Temple.tscn"),
	2: preload("res://GameObjects/Interactable/Key/Key.tscn"),
	3: preload("res://GameObjects/Interactable/Coin/Coin.tscn"),
	4: preload("res://GameObjects/Interactable/Point/Point.tscn")
}

func _ready():
	for cellPosition in self.get_used_cells():
		var cell: int = self.get_cellv(cellPosition)
		if interactableNodes.has(cell):
			var objectNode: Node = interactableNodes[cell].instance()
			objectNode.position = self.map_to_world(cellPosition) + Vector2(8,8)
			add_child(objectNode)
			self.set_cellv(cellPosition, -1)
