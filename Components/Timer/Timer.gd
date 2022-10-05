extends NinePatchRect

signal timesUp
signal timeOut

onready var timerLabel = $Label
onready var timer = $Timer

var minutes:int = 2
var seconds:int = 0

func _ready():
	_displayTimer(minutes, seconds)

func _startTimer():
	_restartTimer()
	timer.start()

func _restartTimer():
	minutes = 2
	seconds = 0
	_countDownTimer()

func _on_Timer_timeout():
	seconds -= 1
	_countDownTimer()

func _countDownTimer():
	if minutes > 0 and seconds <= -1:
		minutes -= 1
		seconds = 59
	
	_displayTimer(minutes, seconds)
	_stopTimer(minutes, seconds)

func _displayTimer(mins, secs):
	var minsText = str(mins)
	var secsText = str(secs)
	
	if secs <= 9:
		secsText = str("0%s" % [secsText])
	
	if mins > 0:
		timerLabel.set_text("%s:%s" % [minsText, secsText])
	else:
		timerLabel.set_text("%s" % [secsText])

func _getTime():
	timer.stop()
	var timeSpent
	
	if minutes == 2 and seconds == 0:
		timeSpent = "0secs ?"
	else:
		if minutes > 0:
			if seconds <= 9:
				timeSpent = "0" + str(60 - seconds) + "secs"
			else:
				timeSpent = str(60 - seconds) + "secs"
		elif minutes == 0:
			if seconds <= 9:
				timeSpent = "1min : " + "0" + str(60 - seconds) + "secs"
			else:
				timeSpent = "1min : " + str(60 - seconds) + "secs"
		
	emit_signal("timesUp", timeSpent)

func _stopTimer(mins, secs):
	if mins == 0 and secs == 0:
		emit_signal("outOfTime", "2mins : 00secs")
		timer.stop()
