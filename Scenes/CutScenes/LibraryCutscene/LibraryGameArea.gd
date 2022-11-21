extends Node

onready var second := $NextFloor
onready var secondCollision := $NextFloor/CollisionShape2D
onready var tween := $Tween
onready var player := $Player
onready var box := $Box
onready var canUndoTime := $Timer

var secondOpen := false
var undoRedoJournal: UndoRedo = UndoRedo.new()
var canUndo: bool = true

func _ready():
	_connectSignal()

func _on_Stairs_body_entered(body):
	if body.name == "Player" and !secondOpen:
		secondOpen = true
		tween.interpolate_property(second, "modulate:a", 1, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		secondCollision.set_deferred("disabled", true)

func _connectSignal():
	player.connect("objectStateChange", self, "_playerJournal")
	player.connect("playerPushed", self, "_playerPushJournal")
	box.connect("boxMoves", self, "_boxJournal")

func _process(delta):
	if Input.is_action_pressed("undo"):
		_undoSystem()

func _playerJournal(object):
	undoRedoJournal.create_action("Move")
	undoRedoJournal.add_undo_method(object, "undoMovement")

	undoRedoJournal.commit_action()

func _playerPushJournal(object):
	undoRedoJournal.create_action("Pushing")
	undoRedoJournal.add_undo_method(object, "undoMovement")

	undoRedoJournal.commit_action()

func _boxJournal(object):
	undoRedoJournal.create_action("Pushed")
	undoRedoJournal.add_undo_method(object, "undoBoxPosition")
	undoRedoJournal.add_undo_method(object, "undoBoxValue", object.boxValue)

	undoRedoJournal.commit_action()

func _undoSystem():
	if !GameManager._getGameOver():
		if !player.moving:
			if canUndo:
				if undoRedoJournal.has_undo():
					match undoRedoJournal.get_current_action_name():
						"Move":
							undoRedoJournal.undo()
						"Pushing":
							for i in 2:	
								undoRedoJournal.undo()
						"Operational Added":
							for i in 3:	
								undoRedoJournal.undo()
					canUndo = false
					canUndoTime.start()

func _on_Timer_timeout():
	canUndo = true
