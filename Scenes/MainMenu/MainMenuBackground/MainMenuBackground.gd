extends Control

export var randomShakeStrength: float = 30.0
export var shakeDecayRate: float = 5.0
export var noiseShakeSpeed: float = 30.0
export var noiseShakeStrength: float = 60.0

onready var bg1 = $BG1
onready var bg2 = $BG2
onready var camera := $Camera2D
onready var noise := OpenSimplexNoise.new()
onready var timer := $Timer
onready var animation := $AnimationPlayer

var randomBackground = [
	load("res://Assets/Textures/LevelBG/Forest/1.jpg"),
	load("res://Assets/Textures/LevelBG/Forest/2.jpg"),
	load("res://Assets/Textures/LevelBG/Forest/3.jpg"),
	load("res://Assets/Textures/LevelBG/Forest/4.jpg"),
	load("res://Assets/Textures/LevelBG/Forest/5.jpg"),
	load("res://Assets/Textures/LevelBG/MagicalVoid/5.jpg"),
	load("res://Assets/Textures/LevelBG/MagicalVoid/6.jpg"),
	load("res://Assets/Textures/LevelBG/MagicalVoid/7.jpg"),
	load("res://Assets/Textures/LevelBG/MagicalVoid/8.jpg"),
	load("res://Assets/Textures/LevelBG/MagicalVoid/9.jpg"),
	load("res://Assets/Textures/LevelBG/Ruins/5.jpg"),
	load("res://Assets/Textures/LevelBG/Ruins/6.jpg"),
	load("res://Assets/Textures/LevelBG/Ruins/7.jpg"),
	load("res://Assets/Textures/LevelBG/Ruins/8.jpg"),
	load("res://Assets/Textures/LevelBG/Ruins/9.jpg"),
	load("res://Assets/Textures/LevelBG/Underground/6.jpg"),
	load("res://Assets/Textures/LevelBG/Underground/7.jpg"),
	load("res://Assets/Textures/LevelBG/Underground/8.jpg"),
	load("res://Assets/Textures/LevelBG/Underground/9.jpg")
]
var rng = RandomNumberGenerator.new()
var noiseI: float = 0.0
var shakeStrength: float = 0.0
var swap: bool = true

func _ready():
	changeBG()
	
	rng.randomize()
	noise.seed = rng.randi()
	noise.period = 2

func changeBG():
	rng.randomize()
	var num = rng.randi_range(0, randomBackground.size() - 1)
	if swap:
		bg2.texture = randomBackground[num]
		animation.play("Crossfade")
		swap = false
	else:
		bg1.texture = randomBackground[num]
		animation.play_backwards("Crossfade")
		swap = true

	timer.start()

func _process(delta):
	shakeStrength = noiseShakeStrength
	shakeStrength = lerp(shakeStrength, 0, shakeDecayRate * delta)
	
	camera.offset = getNoiseOffset(delta)

func getNoiseOffset(delta):
	noiseI += delta * noiseShakeSpeed

	return Vector2(
		noise.get_noise_2d(1, noiseI) * shakeStrength,
		noise.get_noise_2d(100, noiseI) * shakeStrength
	)

func _on_Timer_timeout():
	 changeBG()
