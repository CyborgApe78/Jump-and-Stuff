extends Node2D
class_name WallDetectorComponent


@onready var wallRaycastLeft: ShapeCast2D = $Left
@onready var wallRaycastRight: ShapeCast2D = $Right

var wallDirection: int = 0 
var lastWallDirection: int = 0


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	wall_detection()


func wall_detection(length: int = 5) -> int:
	if wallRaycastLeft.target_position.x != -length:
		wallRaycastLeft.target_position.x = -length
	if wallRaycastRight.target_position.x != length:
		wallRaycastRight.target_position.x = length
	
	if wallRaycastLeft.is_colliding() and wallRaycastRight.is_colliding():
		wallDirection = 0
		return 0
	elif wallRaycastLeft.is_colliding():
		wallDirection = -1
		return -1
	elif wallRaycastRight.is_colliding():
		wallDirection = 1
		return 1
	else:
		wallDirection = 0
		
	if wallDirection != 0:
		lastWallDirection = wallDirection
	
	return 0
