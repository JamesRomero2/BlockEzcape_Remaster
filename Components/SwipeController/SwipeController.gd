extends TouchScreenButton

signal playerSwipeDirection(swipeDirection)
signal playerGestureState(gestureState)

var onArea: bool = false

func _ready():
	_connectSignals()

func _input(event: InputEvent):
	if event is InputEventScreenDrag:
		if getSwipeDirection(event.relative, 1.0) == Vector2.UP:
			emit_signal("playerSwipeDirection", Vector2.UP)
		if getSwipeDirection(event.relative, 1.0) == Vector2.DOWN:
			emit_signal("playerSwipeDirection", Vector2.DOWN)
		if getSwipeDirection(event.relative, 1.0) == Vector2.RIGHT:
			emit_signal("playerSwipeDirection", Vector2.RIGHT)
		if getSwipeDirection(event.relative, 1.0) == Vector2.LEFT:
			emit_signal("playerSwipeDirection", Vector2.LEFT)

func _connectSignals():
	self.connect("pressed", self, "_on_self_pressed")
	self.connect("released", self, "_on_self_released")

func getSwipeDirection(swipe: Vector2, swipe_margin: float):
	var swipeDirection := Vector2.ZERO

	if swipe.x >= -swipe_margin and swipe.x <= swipe_margin and swipe.y >= swipe_margin:
		swipeDirection = Vector2.DOWN
	if swipe.x >= -swipe_margin and swipe.x <= swipe_margin and swipe.y <= -swipe_margin:
		swipeDirection = Vector2.UP
	if swipe.y >= -swipe_margin and swipe.y <= swipe_margin and swipe.x >= swipe_margin:
		swipeDirection = Vector2.RIGHT
	if swipe.y >= -swipe_margin and swipe.y <= swipe_margin and swipe.x <= -swipe_margin:
		swipeDirection = Vector2.LEFT

	if onArea == true:
		return swipeDirection

func _on_self_pressed():
	onArea = true
	# TRUE = Player Holding the Screen, Character is in Looking State
	emit_signal("playerGestureState", true)

func _on_self_released():
	onArea = false
	# FALSE = Player Let Go of the Screen, Character is in Moving State
	emit_signal("playerGestureState", false)
