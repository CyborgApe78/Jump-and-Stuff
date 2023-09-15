extends Node
class_name StatsComponent
#TODO: added underscore for private var/func

var velocityJumpCrouch: float

var jumpApexHeight: float = 40
var jumpCornerCorrectionVertical: int = 10
var jumpCornerCorrectionHorizontal: int = 15
var percentMinJumpVelocity: float = 0.8
var percentKeepJumpConsecutive: float = 0.9
var airTurnModifier: float = 4.0
var upHillFrictionModifier: float = 2.0
var flatGroundFrictionModifier: float = 1.75 #TODO: these need to move to state using them. slide/roll have different values
var downHillAccel: float = 50
 
@export var baseStats: Resource #TODO: create custom class


@export_group("Speed")
## Base movement speed
@export var _baseMove: float = 12:
	set(value):
		_baseMove = value
		moveSpeed = calculate_tile_height(_baseMove)
	get:
		return _baseMove
## This value makes the time it takes to reach maximum speed smoother.
@export_range(0.0 , 2.0, 0.01) var baseAcceleration: float = 1.2
## The force applied to slow down the character's movement.
@export_range(0.0 , 1.0, 0.01) var baseFriction: float = 0.5
## Modulates the rate of horizontal speed decrease during airborne movement.
@export_range(0.0 , 2.0, 0.01) var baseAirMovement: float = 1.0
@onready var moveSpeed: int = calculate_tile_height(_baseMove)
@onready var accelerationGround: float = moveSpeed / baseAcceleration
@onready var frictionGround: float = moveSpeed / baseFriction
@onready var accelerationAir: float = moveSpeed / (baseAcceleration * baseAirMovement)
@onready var frictionAir: float = moveSpeed / (baseFriction * baseAirMovement)


@export_group("Jump") #TODO: all other jumps
## Base Jump Height
@export var _baseJumpHeight: float = 4.0:
	set(value):
		_baseJumpHeight = value
		jumpHeight = calculate_tile_height(_baseJumpHeight + 0.25) ## Gives extra boost to get on platforms
		gravityJump = calculate_gravity()
		gravityFall = calculate_gravity(jumpHeight, _jumpTimeToDescent)
		jumpVelocity = calculate_jump_velocity()
		jumpDoubleVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpDoubleModifier))
		jumpTripleVelocity = calculate_jump_velocity(jumpHeight +calculate_tile_height(_jumpTripleModifier))
	get:
		return _baseJumpHeight
## Time it takes to reach the maximum jump height
@export_range(0.0 , 1.0, 0.01) var _jumpTimeToPeak: float = 0.5:
	set(value):
		_jumpTimeToPeak = value
		gravityJump = calculate_gravity()
		jumpVelocity = calculate_jump_velocity()
		jumpDoubleVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpDoubleModifier))
		jumpTripleVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpTripleModifier))
	get:
		return _jumpTimeToPeak
## Time it takes to reach the floor after jump
@export var _jumpTimeToDescent: float = 0.25:
	set(value):
		_jumpTimeToDescent = value
		gravityFall = calculate_gravity(jumpHeight, _jumpTimeToDescent)
	get:
		return _jumpTimeToDescent
## Time of extra floatyness at peak of jump
@export var _jumpTimeAtApex: float = 0.8:
	set(value):
		_jumpTimeAtApex = value
		gravityFall = calculate_gravity(jumpHeight, _jumpTimeAtApex)
	get:
		return _jumpTimeAtApex
@export_range(0.0 , 5.0, 0.25) var _jumpRunModifier: float = 1.0: 
	set(value):
		_jumpRunModifier = value
		jumpRunVelocity = calculate_jump_velocity(calculate_tile_height(_jumpRunModifier))
		jumpDoubleRunVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpDoubleModifier + _jumpRunModifier))
		jumpTripleRunVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpTripleModifier + _jumpRunModifier))
	get:
		return _jumpRunModifier
@export_range(0.0 , 5.0, 0.25) var _jumpDoubleModifier: float = 2.0:
	set(value):
		_jumpDoubleModifier = value
		jumpDoubleVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpDoubleModifier))
		jumpDoubleRunVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpDoubleModifier + _jumpRunModifier))
	get:
		return _jumpDoubleModifier
@export_range(0.0 , 5.0, 0.25) var _jumpTripleModifier: float = 4.0:
	set(value):
		_jumpTripleModifier = value
		jumpTripleVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpTripleModifier))
		jumpTripleRunVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpTripleModifier + _jumpRunModifier))
	get:
		return _jumpTripleModifier
@export_range(0.0 , 5.0, 0.25) var _jumpFlipModifier: float = 4.0:
	set(value):
		_jumpFlipModifier = value
		jumpFlipVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpFlipModifier))
	get:
		return _jumpFlipModifier
@export_range(0.0 , 5.0, 0.25) var _jumpLongModifier: float = 4.0:
	set(value):
		_jumpLongModifier = value
		jumpLongVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpLongModifier))
	get:
		return _jumpLongModifier
@export_range(0.0 , 5.0, 0.25) var _jumpCrouchModifier: float = 4.0:
	set(value):
		_jumpCrouchModifier = value
		jumpCrouchVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpCrouchModifier))
	get:
		return _jumpCrouchModifier
@export_range(0.0 , 5.0, 0.25) var _jumpApexModifier: float = 4.0:
	set(value):
		_jumpApexModifier = value
		jumpApexVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpApexModifier))
	get:
		return _jumpApexModifier
@export_range(0.0 , 5.0, 0.25) var _jumpGroundPoundModifier: float = 4.0:
	set(value):
		_jumpGroundPoundModifier = value
		jumpGroundPoundVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpGroundPoundModifier))
	get:
		return _jumpGroundPoundModifier
### The value represents a velocity threshold that determines whether the character can jump
#@export var jump_threshold: float = 300.0
### Reduced amount of jump effectiveness at each iteration
#@export var height_reduced_by_jump : int = 0
#
### Enable the coyote jump
#@export var coyote_jump_enabled: bool = true
### The time window this jump can be executed when the character is not on the floor
#@export var coyote_jump_time_window: float = 0.15

@onready var jumpHeight: int = calculate_tile_height(_baseJumpHeight + 0.25)
@onready var gravityJump: float = calculate_gravity(jumpHeight, _jumpTimeToPeak)
@onready var gravityFall: float = calculate_gravity(jumpHeight, _jumpTimeToDescent)
@onready var gravityApex: float = calculate_gravity(jumpHeight, _jumpTimeAtApex)
@onready var jumpVelocity: float = calculate_jump_velocity()
@onready var jumpRunVelocity: float = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpRunModifier))
@onready var jumpDoubleVelocity: float = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpDoubleModifier))
@onready var jumpDoubleRunVelocity: float = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpDoubleModifier + _jumpRunModifier))
@onready var jumpTripleVelocity: float = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpTripleModifier))
@onready var jumpTripleRunVelocity: float = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpTripleModifier + _jumpRunModifier))
@onready var jumpFlipVelocity: float = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpFlipModifier))
@onready var jumpLongVelocity: float = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpLongModifier))
@onready var jumpCrouchVelocity: float = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpCrouchModifier))
@onready var jumpApexVelocity: float = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpApexModifier))
@onready var jumpGroundPoundVelocity: float = calculate_jump_velocity(jumpHeight + calculate_tile_height(_jumpGroundPoundModifier))
@onready var jumpWallVelocity: float

#Odyssey Jump Height
#	Single 258
#	Double 312 / 1.2
#	Triple  550 / 2.1
#	Ground Pound 513 / 2
#	Crouch 496 / 1.9
#	Side Flip 496 / 1.9
#	GP Dive + 182
#	Long 144 / .6

@export_group("Gravity")
## The maximum vertical velocity while falling to control fall speed
@export var maxFall: int = 4:
	set(value):
		terminalVelocity = maxFall * -jumpVelocity
	get:
		return maxFall
@onready var terminalVelocity: int = maxFall * -jumpVelocity

@export_group("Dash")
@export var baseDash: float = 36:
	set(value):
		baseDash = value
		dashSpeed = calculate_tile_height(baseDash)
	get:
		return baseDash
@onready var dashSpeed: int = calculate_tile_height(baseDash) #TODO: change to velocity
##TODO: other categories

#################################

func  _ready() -> void:
	if baseStats:
		pass
		#TODO: resource for custom characters


func stat_update() -> void:
	pass
	#TOOD: check for upgraded stats


func calculate_tile_height(amount: float) -> float:
	return amount * Util.tileSize


func calculate_jump_velocity(height: float = jumpHeight, time: float = _jumpTimeToPeak):
	return -sqrt(2 * gravityJump * height)


func calculate_gravity(height: float = jumpHeight, time: float = _jumpTimeToPeak):
	return (2.0 * height) / pow(time, 2) 
