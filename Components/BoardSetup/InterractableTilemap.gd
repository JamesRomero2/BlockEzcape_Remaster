extends TileMap

var interactableNodes: Dictionary = {
#	FORMAT
#	TILE INDEX : SCENE ABSOLUTE PATH
	0: preload("res://GameObjects/Entity/PlayerV2/Player.tscn"),
	5: preload("res://GameObjects/Interactable/ReaderSlot/ReaderSlot.tscn"),
	9: preload("res://GameObjects/Interactable/ImmovableTile/ImmovableTile.tscn")
}

func _ready():
	for cellPosition in get_used_cells():
		var cell: int = get_cellv(cellPosition)
		if interactableNodes.has(cell):
			var objectNode: Node = interactableNodes[cell].instance()
			objectNode.position = map_to_world(cellPosition) + Vector2(8,8)
			add_child(objectNode)
			self.set_cellv(cellPosition, -1)
