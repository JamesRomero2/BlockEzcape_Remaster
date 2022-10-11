extends TileMap

var numberBlock := preload("res://GameObjects/Interactable/PushableBlocks/PushableBlocks.tscn")
#
#var specialTileNodes: Dictionary = {
##	FORMAT
##	TILE INDEX : SCENE ABSOLUTE PATH
#	0: preload("res://GameObjects/SpecialTiles/ArrowTile/ArrowTile.tscn"),
#	1: preload("res://GameObjects/SpecialTiles/ArrowTile/ArrowTile.tscn"),
#	2: preload("res://GameObjects/SpecialTiles/ArrowTile/ArrowTile.tscn"),
#	3: preload("res://GameObjects/SpecialTiles/ArrowTile/ArrowTile.tscn"),
#	4: preload("res://GameObjects/SpecialTiles/DeathTile/DeathTile.tscn"),
#	5: preload("res://GameObjects/SpecialTiles/SpringTile/SpringTile.tscn"),
#	6: preload("res://GameObjects/SpecialTiles/StopTile/StopTile.tscn"),
#	7: preload("res://GameObjects/SpecialTiles/PortalTile/PortalTile.tscn")
#}

func _ready():
	for cellPosition in get_used_cells():
		var cell: int = get_cellv(cellPosition)
		var objectNode: Node = numberBlock.instance()
		objectNode.boxValue = cell
		objectNode.position = map_to_world(cellPosition) + Vector2(8,8)
		add_child(objectNode)
		self.set_cellv(cellPosition, -1)

