extends KinematicBody2D

onready var arrows: Node2D = $Arrows
onready var verticalCollision: CollisionShape2D = $VerticalCollision
onready var horizontalCollision: CollisionShape2D = $HorizontalCollision

var arrowIndicator: Array = []
var playerCanMove: bool = true
var characterLooking: bool = true
var playerVelocity: Vector2 = Vector2.ZERO
var playerSpeed: int = 16

func _ready():
	var swipeControl = get_node("SwipeControl/Control/TouchScreenButton")
	swipeControl.connect("playerSwipeDirection", self, "_on_TouchScreenButton_swipeDirection")
	swipeControl.connect("playerGestureState", self, "_on_TouchScreenButton_characterState")
	_addArrowsToArray()

func _physics_process(_delta):
#	_playAnimations()
	
	_showArrow(playerVelocity, characterLooking)
	
	# If the player let go of the screen proceed the character to the given direction
	if characterLooking: return

	# Check if the character is in motion, if the character is in motion do not accept direction.
	if playerVelocity != Vector2.ZERO:
		playerCanMove = false

	# Enable and Disbable Horizontal and Vertical Collisions
	if playerVelocity.x != 0:
		horizontalCollision.disabled = false
		verticalCollision.disabled = true
	elif playerVelocity.y != 0:
		horizontalCollision.disabled = true
		verticalCollision.disabled = false

	# Move the player
	var playerCollision: KinematicCollision2D = move_and_collide(playerVelocity * playerSpeed)

	# If the player stops of collided with a wall, enable playerCanMove to accept another direction
	if playerCollision != null:
		playerCanMove = true

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
			arrowIndicator[1].visible = true
		Vector2.LEFT:
			arrowIndicator[2].visible = true

func _hideArrow():
	for i in range(arrowIndicator.size()):
		arrowIndicator[i].visible = false

#func _playAnimations():
#	# If the player hold the screen, Look first to the direction
#	if playerVelocity.x > 0:
#		animations.play("look_right")
#	elif playerVelocity.x < 0:
#		animations.play("look_left")
#	if playerVelocity.y > 0:
#		animations.play("look_backward")
#	elif playerVelocity.y < 0:
#		animations.play("look_forward")

func _on_TouchScreenButton_swipeDirection(swipeDirection: Vector2):
	if playerCanMove:
		playerVelocity = swipeDirection

func _on_TouchScreenButton_characterState(characterState: bool):
	if playerCanMove:
		characterLooking = characterState
