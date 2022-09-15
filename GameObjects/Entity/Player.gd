extends KinematicBody2D

onready var arrows: Node2D = $Arrows
onready var verticalCollision: CollisionShape2D = $VerticalCollision
onready var horizontalCollision: CollisionShape2D = $HorizontalCollision
onready var animations: AnimationPlayer = $AnimationPlayer

var arrowIndicator: Array = []
var playerCanMove: bool = true setget _setPlayerCanMove, _getPlayerCanMove
var characterLooking: bool = true
var playerVelocity: Vector2 = Vector2.ZERO setget _setPlayerVelocity, _getPlayerVelocity
var playerSpeed: int = 8

func _ready():
	var swipeControl = get_node("SwipeController/Control/TouchScreenButton")
	swipeControl.connect("playerSwipeDirection", self, "_on_TouchScreenButton_swipeDirection")
	swipeControl.connect("playerGestureState", self, "_on_TouchScreenButton_characterState")
	_addArrowsToArray()

func _physics_process(_delta):
	_playAnimations()
	
	_showArrow(_getPlayerVelocity(), characterLooking)
	
	# If the player let go of the screen proceed the character to the given direction
	if characterLooking: return

	# Check if the character is in motion, if the character is in motion do not accept direction.
	if _getPlayerVelocity() != Vector2.ZERO:
		_setPlayerCanMove(false)

	# Enable and Disbable Horizontal and Vertical Collisions
	if _getPlayerVelocity().x != 0:
		horizontalCollision.disabled = false
		verticalCollision.disabled = true
	elif _getPlayerVelocity().y != 0:
		horizontalCollision.disabled = true
		verticalCollision.disabled = false

	# Move the player
	var playerCollision: KinematicCollision2D = move_and_collide(_getPlayerVelocity() * playerSpeed)

	# If the player stops of collided with a wall, enable playerCanMove to accept another direction
	if playerCollision != null:
		_setPlayerCanMove(true)

func _addArrowsToArray():
	for arrow in arrows.get_children():
		arrowIndicator.push_back(arrow)

	_hideArrow()

func _showArrow(direction: Vector2, lookingState: bool):
	_hideArrow()
	
	if !lookingState: return
	
	match direction:
		Vector2.UP:
			arrowIndicator[0].visible = true
		Vector2.RIGHT:
			arrowIndicator[1].visible = true
		Vector2.DOWN:
			arrowIndicator[2].visible = true
		Vector2.LEFT:
			arrowIndicator[3].visible = true

func _hideArrow():
	for i in range(arrowIndicator.size()):
		arrowIndicator[i].visible = false

func _playAnimations():
	# If the player hold the screen, Look first to the direction
	if playerVelocity.x > 0:
		animations.play("LookRight")
	elif playerVelocity.x < 0:
		animations.play("LookLeft")
	if playerVelocity.y > 0:
		animations.play("LookBackward")
	elif playerVelocity.y < 0:
		animations.play("LookForward")

func _on_TouchScreenButton_swipeDirection(swipeDirection: Vector2):
	if _getPlayerCanMove():
		_setPlayerVelocity(swipeDirection)

func _on_TouchScreenButton_characterState(characterState: bool):
	if _getPlayerCanMove():
		characterLooking = characterState

func _setPlayerCanMove(value):
	playerCanMove = value

func _getPlayerCanMove():
	return playerCanMove

func _setPlayerVelocity(value):
	playerVelocity = value

func _getPlayerVelocity():
	return playerVelocity
