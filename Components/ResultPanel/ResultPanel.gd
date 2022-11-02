extends CanvasLayer

var timeSpent: String
var medal: int = 0
var verdict: bool
var animating: bool = true
var worldMap = "res://Scenes/WorldMap/WorldMap.tscn"

func _showResult(mins, secs):
	timeSpent = "%02d : %02d" % [mins, secs]
	self.visible = !self.visible
	_setMedalRanking(mins, secs)
	$Container/Label4.text = timeSpent
	$AnimationPlayer.play("ResultsAnimation")

func _input(event):
	if event.is_pressed() and !animating:
		if event.is_action_pressed("space"):
			SceneTransition._changeScene(worldMap)

func _setMedalRanking(mins, secs):
	for medal in $Container/Awards.get_children():
		medal.visible = false

	var minutes = int(mins)
	var seconds = int(secs)
	if minutes == 0:
		if seconds <= 25:
			medal = 4
			$Container/Label6.text = "S"
			$Container/Awards/Platinum.visible = true
		elif seconds >= 26 and seconds <= 50:
			medal = 3
			$Container/Label6.text = "A"
			$Container/Awards/Gold.visible = true
		elif seconds >= 51:
			medal = 2
			$Container/Label6.text = "B"
			$Container/Awards/Silver.visible = true
	elif minutes == 1:
		if seconds <= 25:
			medal = 2
			$Container/Label6.text = "B"
			$Container/Awards/Silver.visible = true
		elif seconds >= 26 and seconds <= 50:
			medal = 1
			$Container/Label6.text = "C"
			$Container/Awards/Bronze.visible = true
		elif seconds >= 51:
			medal = 0
			$Container/Label6.text = "D"
			$Container/Awards/Copper.visible = true
	else:
		medal = 0
		$Container/Label6.text = "D"
		$Container/Awards/Copper.visible = true

func _newLevelUnlocked(value):
	if medal >= value:
		verdict = true
		return true
	verdict = false
	return false

func _playDialog():
	var newLevelDialog := "/Results/NewLevelDialog"
	var tryAgainDialog := "/Results/TryAgainDialog"
	var dialog
	
	if get_node_or_null('DialogNode') == null:
		GameManager._setGamePaused(true)
		if verdict:
			dialog = Dialogic.start(newLevelDialog)
		else:
			dialog = Dialogic.start(tryAgainDialog)
		dialog.connect('timeline_end', self, '_dialogEnd')
		add_child(dialog)

func _dialogEnd(_timeline_name):
	GameManager._setGamePaused(false)
	animating = false
