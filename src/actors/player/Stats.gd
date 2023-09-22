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

@export_group("Jump")
## Base Jump Height
@export var _baseJumpHeight: float = 4.0:
	set(value):
		_baseJumpHeight = value
		jumpHeight = calculate_tile_height(_baseJumpHeight + _jumpHeightPlatformBoost)
	get:
		return _baseJumpHeight
## Gives extra boost to get on platforms
@export_range(0.0 , 1.0, 0.05) var _jumpHeightPlatformBoost: float = 0.25:
	set(value):
		_jumpHeightPlatformBoost = value
		jumpHeight = calculate_tile_height(_baseJumpHeight + _jumpHeightPlatformBoost)
	get:
		return _jumpHeightPlatformBoost
## Time it takes to reach the maximum jump height
@export_range(0.0 , 1.0, 0.25) var _jumpTimeToPeak: float = 0.5:
	set(value):
		_jumpTimeToPeak = value
		gravityJump = calculate_gravity()
		jumpVelocity = calculate_jump_velocity()
		jumpDoubleVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpDoubleModifier + _jumpHeightPlatformBoost))
		jumpTripleVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpTripleModifier + _jumpHeightPlatformBoost))
	get:
		return _jumpTimeToPeak
## Time it takes to reach the floor after jump
@export_range(0.0 , 1.0, 0.25) var _jumpTimeToDescent: float = 0.25:
	set(value):
		_jumpTimeToDescent = value
		gravityFall = calculate_gravity(jumpHeight, _jumpTimeToDescent)
		gravityGlide = calculate_gravity(jumpHeight, _jumpTimeToDescent * _glideModifier)
	get:
		return _jumpTimeToDescent
## Time of extra floatyness at peak of jump
@export_range(0.0 , 1.0, 0.05) var _jumpTimeAtApex: float = 0.8:
	set(value):
		_jumpTimeAtApex = value
		gravityFall = calculate_gravity(jumpHeight, _jumpTimeAtApex)
	get:
		return _jumpTimeAtApex
@export_range(0.0 , 5.0, 0.25) var _jumpRunModifier: float = 1.0: 
	set(value):
		_jumpRunModifier = value
		jumpRunVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight + _jumpRunModifier + _jumpHeightPlatformBoost))
		jumpDoubleRunVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpDoubleModifier + _jumpRunModifier + _jumpHeightPlatformBoost))
		jumpTripleRunVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpTripleModifier + _jumpRunModifier + _jumpHeightPlatformBoost))
	get:
		return _jumpRunModifier
@export_range(0.0 , 5.0, 0.25) var _jumpDoubleModifier: float = 1.5:
	set(value):
		_jumpDoubleModifier = value
		jumpDoubleVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpDoubleModifier + _jumpHeightPlatformBoost))
		jumpDoubleRunVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpDoubleModifier + _jumpRunModifier + _jumpHeightPlatformBoost))
	get:
		return _jumpDoubleModifier
@export_range(0.0 , 5.0, 0.25) var _jumpTripleModifier: float = 2.0:
	set(value):
		_jumpTripleModifier = value
		jumpTripleVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpTripleModifier + _jumpHeightPlatformBoost))
		jumpTripleRunVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpTripleModifier + _jumpRunModifier + _jumpHeightPlatformBoost))
	get:
		return _jumpTripleModifier
@export_range(0.0 , 5.0, 0.25) var _jumpFlipModifier: float = 1.75:
	set(value):
		_jumpFlipModifier = value
		jumpFlipVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpFlipModifier + _jumpHeightPlatformBoost))
	get:
		return _jumpFlipModifier
@export_range(0.0 , 5.0, 0.25) var _jumpLongModifier: float = 0.5:
	set(value):
		_jumpLongModifier = value
		jumpLongVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpLongModifier + _jumpHeightPlatformBoost))
	get:
		return _jumpLongModifier
@export_range(0.0 , 5.0, 0.25) var _jumpCrouchModifier: float = 2.5:
	set(value):
		_jumpCrouchModifier = value
		jumpCrouchVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpCrouchModifier + _jumpHeightPlatformBoost))
	get:
		return _jumpCrouchModifier
@export_range(0.0 , 5.0, 0.25) var _jumpGroundPoundModifier: float = 3.0:
	set(value):
		_jumpGroundPoundModifier = value
		jumpGroundPoundVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpGroundPoundModifier + _jumpHeightPlatformBoost))
	get:
		return _jumpGroundPoundModifier

#Odyssey Jump Height
#	Single 258
#	Double 312 / 1.2
#	Triple  550 / 2.1
#	Ground Pound 513 / 2
#	Crouch 496 / 1.9
#	Side Flip 496 / 1.9
#	GP Dive + 182
#	Long 144 / .6

@onready var jumpHeight: int = calculate_tile_height(_baseJumpHeight + _jumpHeightPlatformBoost)
@onready var gravityJump: float = calculate_gravity(jumpHeight, _jumpTimeToPeak)
@onready var gravityFall: float = calculate_gravity(jumpHeight, _jumpTimeToDescent)
@onready var gravityApex: float = calculate_gravity(jumpHeight, _jumpTimeAtApex)
@onready var jumpVelocity: float = calculate_jump_velocity()
@onready var jumpRunVelocity: float = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight + _jumpRunModifier + _jumpHeightPlatformBoost))
@onready var jumpDoubleVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpDoubleModifier + _jumpHeightPlatformBoost))
@onready var jumpDoubleRunVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpDoubleModifier + _jumpRunModifier + _jumpHeightPlatformBoost))
@onready var jumpTripleVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpTripleModifier + _jumpHeightPlatformBoost))
@onready var jumpTripleRunVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpTripleModifier + _jumpRunModifier + _jumpHeightPlatformBoost))
@onready var jumpFlipVelocity: float = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpFlipModifier + _jumpHeightPlatformBoost))
@onready var jumpLongVelocity: float = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpLongModifier + _jumpHeightPlatformBoost))
@onready var jumpCrouchVelocity: float = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpCrouchModifier + _jumpHeightPlatformBoost))
@onready var jumpGroundPoundVelocity: float = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpGroundPoundModifier + _jumpHeightPlatformBoost))

@export_range(0.0 , 5.0, 0.1) var _jumpLongSpeedModifier: float = 1.35:
	set(value):
		_jumpLongSpeedModifier = value
		jumpLongSpeed = calculate_tile_height(_baseMove * _jumpLongSpeedModifier)
	get:
		return _jumpLongSpeedModifier
@export_range(0.0 , 5.0, 0.1) var _jumpLongSpeedChainModifier: float = 1.5:
	set(value):
		_jumpLongSpeedChainModifier = value
		jumpLongChainSpeed = calculate_tile_height(_baseMove * _jumpLongSpeedChainModifier)
	get:
		return _jumpLongSpeedChainModifier

@onready var jumpLongSpeed: int = calculate_tile_height(_baseMove * _jumpLongSpeedModifier)
@onready var jumpLongChainSpeed: int = calculate_tile_height(_baseMove * _jumpLongSpeedChainModifier)
#TODO: wall jump speed
#if player.moveDirection.y == -1:
#		player.velocity = Vector2(100 * -jumpDirection, stats.jumpVelocity * 1.0)
#	## down pressed
#	elif player.moveDirection.y == 1:
#		player.velocity = Vector2(300 * -jumpDirection, 100)
#	## no directional input
#	elif player.moveDirection.x == 0:
#		player.velocity = Vector2(max(stats.moveSpeed / 1.5 , abs(player.velocityPrevious.x)) * -jumpDirection, stats.jumpVelocity * 0.9)
#	## away from wall pressed
#	elif player.moveDirection.x == -jumpDirection:
#		player.velocity = Vector2(stats.moveSpeed * -jumpDirection, stats.jumpVelocity * 0.7)
#	## towards from wall pressed
#	elif player.moveDirection.x == jumpDirection: ) 
#		player.velocity = Vector2(200 * -jumpDirection, stats.jumpVelocity * 0.8)


@export_group("Wall Jump")
@export_range(0.0 , 5.0, 0.25) var _wallJumpUpModifier: float = 1.0:
	set(value):
		_wallJumpUpModifier = value
		wallJumpUpVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_wallJumpUpModifier))
	get:
		return _wallJumpUpModifier
@export_range(0.0 , 5.0, 0.25) var _wallJumpDownModifier: float = 1.0:
	set(value):
		_wallJumpDownModifier = value
		wallJumpUpVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_wallJumpDownModifier))
	get:
		return _wallJumpDownModifier
@export_range(0.0 , 5.0, 0.25) var _wallJumpNeutralModifier: float = 1.0:
	set(value):
		_wallJumpNeutralModifier = value
		wallJumpUpVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_wallJumpNeutralModifier))
	get:
		return _wallJumpNeutralModifier
@export_range(0.0 , 5.0, 0.25) var _wallJumpAwayModifier: float = 1.0:
	set(value):
		_wallJumpAwayModifier = value
		wallJumpUpVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_wallJumpAwayModifier))
	get:
		return _wallJumpAwayModifier
@export_range(0.0 , 5.0, 0.25) var _wallJumpTowardModifier: float = 1.0:
	set(value):
		_wallJumpTowardModifier = value
		wallJumpUpVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_wallJumpTowardModifier))
	get:
		return _wallJumpTowardModifier

@onready var wallJumpUpVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_wallJumpUpModifier))
@onready var wallJumpDownVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_wallJumpDownModifier))
@onready var wallJumpAwayVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_wallJumpNeutralModifier))
@onready var wallJumpTowardVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_wallJumpTowardModifier))

@export_group("Gravity")
## The maximum vertical velocity while falling to control fall speed
@export var _maxFall: int = 4:
	set(value):
		terminalVelocity = _maxFall * -jumpVelocity
		terminalGlideVelocity = _maxFall * _glideModifier * -jumpVelocity
	get:
		return _maxFall
@onready var terminalVelocity: int = _maxFall * -jumpVelocity

@export_group("Glide")
@export_range(0.0 , 5.0, 0.05) var _glideModifier: float = 0.1:
	set(value):
		_glideModifier = value
		gravityGlide = calculate_gravity(jumpHeight, _jumpTimeToDescent / _glideModifier)
		terminalGlideVelocity = _maxFall * _glideModifier * -jumpVelocity
	get:
		return _glideModifier
@onready var gravityGlide = calculate_gravity(jumpHeight, _jumpTimeToDescent / _glideModifier)
@onready var terminalGlideVelocity: int = _maxFall * _glideModifier * -jumpVelocity
@export var glidevelocityModifier: float = 0.6 #TODO: move to speed

@export_group("Dive") #TODO:
@export var diveSpeedMultiplier: float = 1.6
@export var multiplierGroundPound: float = 1.5

@export_group("Slide") #TODO:
var upHillFrictionModifier: float = 2.0
var flatGroundFrictionModifier: float = 1.75 #TODO: these need to move to state using them. slide/roll have different values
var downHillAccel: float = 50
@export var jumpModifier: float = 0.25
@export var slidevelocityModifier: float = 1.0
var velocityHop: float

@export_group("Wall Slide") #TODO:
var wallSlideFriction
var downpressedFriction

@export_group("Dash") #TODO:
@export var baseDash: float = 36:
	set(value):
		baseDash = value
		dashSpeed = calculate_tile_height(baseDash)
	get:
		return baseDash
@onready var dashSpeed: int = calculate_tile_height(baseDash) #TODO: change to velocity

@export_group("GroundPound")
@export var _baseGPHeight: float = 2.0:
	set(value):
		_baseGPHeight = value
		gpVelocity = calculate_jump_velocity(calculate_tile_height(_baseGPHeight + _jumpHeightPlatformBoost), _gpTimeToPeak)
	get:
		return _baseGPHeight
@export_range(0.0 , 1.0, 0.25) var _gpTimeToPeak: float = 0.2:
	set(value):
		_gpTimeToPeak = value
		gpVelocity = calculate_jump_velocity(calculate_tile_height(_baseGPHeight + _jumpHeightPlatformBoost), _gpTimeToPeak)
	get:
		return _gpTimeToPeak
@onready var gpVelocity: float = calculate_jump_velocity(calculate_tile_height(_baseGPHeight + _jumpHeightPlatformBoost), _gpTimeToPeak)
@export_range(0.0 , 5.0, 0.05) var _gpModifier: float = 2.0:
	set(value):
		_gpModifier = value
		gravityGP = calculate_gravity(jumpHeight, _jumpTimeToDescent / _gpModifier)
		terminalGlideVelocity = _maxFall * _gpModifier * -jumpVelocity
	get:
		return _gpModifier
@onready var gravityGP = calculate_gravity(jumpHeight, _jumpTimeToDescent / _gpModifier)
@onready var terminalGPVelocity: int = _maxFall * _gpModifier * -jumpVelocity

@export_group("Grapple") #TODO:

@export_group("Bash") #TODO:

@export_group("Spin")
@export var _baseSpinHeight: float = 1.0:
	set(value):
		_baseSpinHeight = value
		jumpHeight = calculate_tile_height(_baseSpinHeight + _jumpHeightPlatformBoost)
	get:
		return _baseSpinHeight
@onready var spinHeight: int = calculate_tile_height(_baseSpinHeight + _jumpHeightPlatformBoost)

@export_group("Roll") #TODO:

@export_group("Swim") #TODO:

@export_group("Burrow") #TODO:

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
