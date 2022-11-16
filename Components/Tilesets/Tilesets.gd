extends Node2D

onready var blocks := $Blocks
export(String, "Forest", "Underground", "Dungeon", "Magical") var selectedBlockType
const block := preload("res://GameObjects/Blocks/ImmovableBlock/ImmovableBlock.tscn")

func _ready():
	for cellPosition in blocks.get_used_cells():
		var cell = blocks.get_cellv(cellPosition)
		if cell == 0:
			var blockObject = block.instance()
			blockObject.blockType = selectedBlockType
			blockObject.position = blocks.map_to_world(cellPosition) + Vector2(8,8)
			call_deferred("add_child", blockObject)
			blocks.set_cellv(cellPosition, -1)
