extends TileMap

var specialTileNodes: Dictionary = {
#	FORMAT
#	TILE INDEX : SCENE ABSOLUTE PATH
	0: preload("res://GameObjects/SpecialTiles/ArrowTile/ArrowTile.tscn"),
	1: preload("res://GameObjects/SpecialTiles/ArrowTile/ArrowTile.tscn"),
	2: preload("res://GameObjects/SpecialTiles/ArrowTile/ArrowTile.tscn"),
	3: preload("res://GameObjects/SpecialTiles/ArrowTile/ArrowTile.tscn"),
	4: preload("res://GameObjects/SpecialTiles/DeathTile/DeathTile.tscn"),
	5: preload("res://GameObjects/SpecialTiles/SpringTile/SpringTile.tscn"),
	6: preload("res://GameObjects/SpecialTiles/StopTile/StopTile.tscn"),
	7: preload("res://GameObjects/SpecialTiles/PortalTile/PortalTile.tscn")
}

func _ready():
	for cellPosition in get_used_cells():
		var cell: int = get_cellv(cellPosition)
		if specialTileNodes.has(cell):
			var objectNode: Node = specialTileNodes[cell].instance()
			
			match cell:
				0:
					objectNode.direction = "Up"
				1:
					objectNode.direction = "Left"
				2:
					objectNode.direction = "Down"
				3:
					objectNode.direction = "Right"

			objectNode.position = map_to_world(cellPosition) + Vector2(8,8)
			add_child(objectNode)
			self.set_cellv(cellPosition, -1)
			
			
