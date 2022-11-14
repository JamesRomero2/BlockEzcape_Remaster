extends Control

onready var progressBar = $Control/Progress

var loader
var loadingStatus
var root
var currentScene

var levelAddresses = {
	"MainMenu" : "res://Scenes/MainMenu/MainMenu.tscn",
	"Credits" : "res://Scenes/Credits/Credits.tscn",
	"WorldMap" : "res://Scenes/WorldMap/WorldMap.tscn",
	"Level 00" : "res://Scenes/CutScenes/Intro/Intro.tscn",
	"LibraryCutScene" : "res://Scenes/CutScenes/LibraryCutscene/LibraryCutscene.tscn",
	"LabvrinthDoorScene" : "res://Scenes/CutScenes/DoorCutscene/DoorCutscene.tscn",
	"Level 01" : "res://Scenes/Stages/Forest/Level 01.tscn",
	"Level 02" : "res://Scenes/Stages/Forest/Level 02.tscn",
	"Level 03" : "res://Scenes/Stages/Forest/Level 03.tscn",
	"Level 04" : "res://Scenes/Stages/Forest/Level 04.tscn",
	"Level 05" : "res://Scenes/Stages/BossStage/TheSerpent/Level 05.tscn",
	"Level 06" : "res://Scenes/Stages/Underground/Level 06.tscn",
	"Level 07" : "res://Scenes/Stages/Underground/Level 07.tscn",
	"Level 08" : "res://Scenes/Stages/Underground/Level 08.tscn",
	"Level 09" : "res://Scenes/Stages/Underground/Level 09.tscn",
	"Level 10" : "res://Scenes/Stages/BossStage/TheGolem/Level 10.tscn",
	"Level 11" : "res://Scenes/Stages/Ruins/Level 11.tscn",
	"Level 12" : "res://Scenes/Stages/Ruins/Level 12.tscn",
	"Level 13" : "res://Scenes/Stages/Ruins/Level 13.tscn",
	"Level 14" : "res://Scenes/Stages/Ruins/Level 14.tscn",
	"Level 15" : "",
	"Level 16" : "res://Scenes/Stages/Void/Level 16.tscn",
	"Level 17" : "res://Scenes/Stages/Void/Level 17.tscn",
	"Level 18" : "res://Scenes/Stages/Void/Level 18.tscn",
	"Level 19" : "res://Scenes/Stages/Void/Level 19.tscn",
	"Level 20" : ""
}

func _ready():
	visible = false
	root = get_tree().get_root()
	currentScene = root.get_child(root.get_child_count() - 1)

func loadLevel(level):
	currentScene = root.get_child(root.get_child_count() - 1)
	currentScene.queue_free()
	loader = ResourceLoader.load_interactive(levelAddresses[level])
	
	if loader == null:
		return
	visible = true
	set_process(true)

func _process(delta):
	if loader == null:
		set_process(false)
		return
	
	loadingStatus = loader.poll()
	if loadingStatus == ERR_FILE_EOF:
		progressBar.value = 100
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		var loadedLevel = loader.get_resource()
		visible = false
		loader = null
		startLevel(loadedLevel)
	elif loadingStatus == OK:
		updateProgress()
	else:
		pass

func updateProgress():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	progressBar.value = progress * 100

func startLevel(loadedLevel):
	currentScene = loadedLevel.instance()
	root.add_child(currentScene)
