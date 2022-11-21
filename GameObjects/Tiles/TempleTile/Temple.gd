extends Area2D

signal levelAccomplish

export(String, "Forest", "Underground", "Dungeon", "Magical") var portalTheme

onready var spriteTexture: AnimatedSprite = $AnimatedSprite
onready var animation: AnimationPlayer = $AnimationPlayer
onready var tween: Tween = $Tween
onready var whirlpool:= $Whirlpool

var doorState: bool = false setget _setDoorState, _getDoorState
var answer : bool = false setget _setAnswer, _getAnswer
var door: bool = false

func _ready():
	spriteTexture.animation = portalTheme
	match portalTheme:
		"Forest":
			whirlpool.modulate = Color(1, 24.50, 2.15, 0.4)
		"Underground":
			whirlpool.modulate = Color(73.89, 21.52, 5.6, 0.2)
		"Dungeon":
			whirlpool.modulate = Color(14.27, 14.34, 24.49, 0.4)
		"Magical":
			whirlpool.modulate = Color(28.41, 3.17, 100, 0.44)

func _setTexture():
	if _getDoorState():
		if !door:
			tween.interpolate_property(spriteTexture, "scale", Vector2(0, 0), Vector2(0.5, 0.5), 0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
			door = true
			whirlpool.emitting = true
		tween.start()
	else:
		if door:
			tween.interpolate_property(spriteTexture, "scale", Vector2(0.5, 0.5), Vector2(0, 0),  0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
			door = false
			whirlpool.emitting = false
		tween.start()

func _on_Temple_body_entered(body):
	if body.name == "Player" and _getDoorState():
		if _getAnswer():
			emit_signal("levelAccomplish")

func _setDoorState(value):
	doorState = value

func _getDoorState():
	return doorState 

func _setAnswer(value):
	answer = value

func _getAnswer():
	return answer 
