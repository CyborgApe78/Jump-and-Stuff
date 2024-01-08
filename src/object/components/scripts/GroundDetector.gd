extends Node2D
class_name GroundDetectorComponent

#TODO: ledge animation
#TODO: look into using built in


@onready var detectorGroundLeft: RayCast2D = $Left
@onready var detectorGroundRight: RayCast2D = $Right
@onready var parent = get_parent() as CharacterBody2D

@export var isSemisolidGround: bool = true

var ledgeLeft: bool
var ledgeRight: bool
var groundAngle: float
var angleDirection: int


func _ready() -> void:
	for child in get_children():
		if child == RayCast2D or ShapeCast2D:
			child.set_collision_mask_value(CollisionLayers.Ground, true)
			if isSemisolidGround:
				child.set_collision_mask_value(CollisionLayers.Semisolid, true)


func _process(delta: float) -> void:
	get_slope_angle()
	
	if parent.is_on_floor():
		ledge_detection()


func ledge_detection() -> void:
	if parent.is_on_floor() and !detectorGroundLeft.is_colliding():
		ledgeLeft = true
	else:
		ledgeLeft = false
	
	if parent.is_on_floor() and !detectorGroundRight.is_colliding():
		ledgeRight = true
	else:
		ledgeRight = false


func get_slope_angle() -> void:
	if detectorGroundLeft.is_colliding() or detectorGroundRight.is_colliding(): ## angles the player to the ground
		var leftAngle: float = detectorGroundLeft.get_collision_normal().angle() + PI/2
		var rightAngle: float = detectorGroundRight.get_collision_normal().angle() + PI/2
		
		if !detectorGroundRight.is_colliding():
			groundAngle = leftAngle
		if !detectorGroundLeft.is_colliding():
			groundAngle = rightAngle
		else:
			groundAngle = (leftAngle + rightAngle)/2
	else:
		groundAngle = 0
	
	if abs(groundAngle) < 0.0001:
		groundAngle = 0
