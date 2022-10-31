extends CanvasLayer

var timeSpent: String
var medal: int = 0

func _showResult(mins, secs):
	timeSpent = "%02d : %02d" % [mins, secs]
	self.visible = !self.visible
	_setMedalRanking(mins, secs)
	$Container/Label4.text = timeSpent
#	$AnimationPlayer.play("ResultAnimation")

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
		return true
	return false
