extends NinePatchRect

signal timesUp

onready var timerLabel = $Label
onready var timer = $Timer

var minutes:int = 2
var seconds:int = 0

func _ready():
	_displayTimer(minutes, seconds)

func _startTimer():
	timer.start()

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

func _stopTimer(mins, secs):
	if mins == 0 and secs == 0:
		print("Time's Up")
		emit_signal("timesUp")
		timer.stop()
