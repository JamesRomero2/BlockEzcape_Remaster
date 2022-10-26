extends Node2D

onready var blocks := $Blocks
const forestBlock := preload("res://GameObjects/Blocks/Underground/ImmovableBlocks/ImmovableBlock.tscn")

func _ready():
	for cellPosition in blocks.get_used_cells():
		var cell = blocks.get_cellv(cellPosition)
		if cell == 0:
			var blockObject = forestBlock.instance()
			blockObject.position = blocks.map_to_world(cellPosition) + Vector2(8,8)
			add_child(blockObject)
			blocks.set_cellv(cellPosition, -1)
