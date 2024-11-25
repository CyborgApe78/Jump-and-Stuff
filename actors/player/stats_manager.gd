class_name StatsManager extends Node

var velocityJumpCrouch: float

var jumpApexHeight: float = 40
var jumpCornerCorrectionVertical: int = 10
var jumpCornerCorrectionHorizontal: int = 15
var percentMinJumpVelocity: float = 0.8
var percentKeepJumpConsecutive: float = 0.9
var airTurnModifier: float = 4.0


@export_group("Speed")
## Base movement speed
@export var _baseMove: float = 12:
	set(value):
		_baseMove = value
		moveSpeed = calculate_tile_height(_baseMove)
	get:
		return _baseMove
## This value makes the time it takes to reach maximum speed smoother.
@export_range(0.0 , 2.0, 0.01) var _baseAcceleration: float = 1.2:
	set(value):
		_baseAcceleration = value
		accelerationGround = moveSpeed / _baseAcceleration
		accelerationAir = moveSpeed / (_baseAcceleration * _baseAirMovement)
		frictionAir = moveSpeed / (_baseFriction * _baseAirMovement)
	get:
		return _baseAcceleration
## The force applied to slow down the character's movement.
@export_range(0.0 , 1.0, 0.01) var _baseFriction: float = 0.2:
	set(value):
		_baseFriction = value
		frictionGround = moveSpeed / _baseFriction
		accelerationAir = moveSpeed / (_baseAcceleration * _baseAirMovement)
		frictionAir = moveSpeed / (_baseFriction * _baseAirMovement)
	get:
		return _baseFriction
## Modulates the rate of horizontal speed decrease during airborne movement.
@export_range(0.0 , 2.0, 0.01) var _baseAirMovement: float = 1.0:
	set(value):
		_baseAirMovement = value
		accelerationAir = moveSpeed / (_baseAcceleration * _baseAirMovement)
		frictionAir = moveSpeed / (_baseFriction * _baseAirMovement)
	get:
		return _baseAirMovement

@onready var moveSpeed: int = calculate_tile_height(_baseMove)
@onready var accelerationGround: float = moveSpeed / _baseAcceleration
@onready var frictionGround: float = moveSpeed / _baseFriction
@onready var accelerationAir: float = moveSpeed / (_baseAcceleration * _baseAirMovement)
@onready var frictionAir: float = moveSpeed / (_baseFriction * _baseAirMovement)


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
@export_range(0.0 , 1.0, 0.05) var _jumpTimeToPeak: float = 0.5:
	set(value):
		_jumpTimeToPeak = value
		gravityJump = calculate_gravity()
		jumpVelocity = calculate_jump_velocity()
		jumpDoubleVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpDoubleModifier + _jumpHeightPlatformBoost))
		jumpTripleVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpTripleModifier + _jumpHeightPlatformBoost))
	get:
		return _jumpTimeToPeak
## Time it takes to reach the floor after jump
@export_range(0.0 , 1.0, 0.05) var _jumpTimeToDescent: float = 0.25:
	set(value):
		_jumpTimeToDescent = value
		gravityFall = calculate_gravity(jumpHeight, _jumpTimeToDescent)
		gravityGlide = calculate_gravity(jumpHeight, _jumpTimeToDescent * _glideSpeedModifier)
	get:
		return _jumpTimeToDescent
## Time of extra floatyness at peak of jump
@export_range(0.0 , 1.0, 0.05) var _jumpTimeAtApex: float = 0.8:
	set(value):
		_jumpTimeAtApex = value
		gravityFall = calculate_gravity(jumpHeight, _jumpTimeAtApex)
	get:
		return _jumpTimeAtApex
@export_range(0.0 , 5.0, 0.05) var _jumpRunModifier: float = 1.0: 
	set(value):
		_jumpRunModifier = value
		jumpRunVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight + _jumpRunModifier + _jumpHeightPlatformBoost))
		jumpDoubleRunVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpDoubleModifier + _jumpRunModifier + _jumpHeightPlatformBoost))
		jumpTripleRunVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpTripleModifier + _jumpRunModifier + _jumpHeightPlatformBoost))
	get:
		return _jumpRunModifier
@export_range(0.0 , 5.0, 0.05) var _jumpDoubleModifier: float = 1.5:
	set(value):
		_jumpDoubleModifier = value
		jumpDoubleVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpDoubleModifier + _jumpHeightPlatformBoost))
		jumpDoubleRunVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpDoubleModifier + _jumpRunModifier + _jumpHeightPlatformBoost))
	get:
		return _jumpDoubleModifier
@export_range(0.0 , 5.0, 0.05) var _jumpTripleModifier: float = 2.0:
	set(value):
		_jumpTripleModifier = value
		jumpTripleVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpTripleModifier + _jumpHeightPlatformBoost))
		jumpTripleRunVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpTripleModifier + _jumpRunModifier + _jumpHeightPlatformBoost))
	get:
		return _jumpTripleModifier
@export_range(0.0 , 5.0, 0.05) var _jumpFlipModifier: float = 1.75:
	set(value):
		_jumpFlipModifier = value
		jumpFlipVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpFlipModifier + _jumpHeightPlatformBoost))
	get:
		return _jumpFlipModifier
@export_range(0.0 , 5.0, 0.05) var _jumpLongModifier: float = 0.5:
	set(value):
		_jumpLongModifier = value
		jumpLongVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpLongModifier + _jumpHeightPlatformBoost))
	get:
		return _jumpLongModifier
@export_range(0.0 , 5.0, 0.05) var _jumpCrouchModifier: float = 1.25:
	set(value):
		_jumpCrouchModifier = value
		jumpCrouchVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpCrouchModifier + _jumpHeightPlatformBoost))
	get:
		return _jumpCrouchModifier
@export_range(0.0 , 5.0, 0.05) var _jumpCrouchChargedModifier: float = 2.5:
	set(value):
		_jumpCrouchChargedModifier = value
		jumpCrouchChargedVelocity = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpCrouchChargedModifier + _jumpHeightPlatformBoost))
	get:
		return _jumpCrouchChargedModifier
@export_range(0.0 , 5.0, 0.05) var _jumpGroundPoundModifier: float = 3.0:
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
@onready var jumpCrouchChargedVelocity: float = calculate_jump_velocity(calculate_tile_height(_baseJumpHeight * _jumpCrouchChargedModifier + _jumpHeightPlatformBoost))
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


@export_group("Gravity")
## The maximum vertical velocity while falling to control fall speed
@export var _maxFall: int = 4:
	set(value):
		terminalVelocity = _maxFall * -jumpVelocity
		terminalGlideVelocity = _maxFall * _glideSpeedModifier * -jumpVelocity
	get:
		return _maxFall
@onready var terminalVelocity: int = _maxFall * -jumpVelocity

@export_group("Glide")
@export_range(0.0 , 5.0, 0.05) var _glideSpeedModifier: float = 0.1:
	set(value):
		_glideSpeedModifier = value
		gravityGlide = calculate_gravity(jumpHeight, _jumpTimeToDescent / _glideSpeedModifier)
		terminalGlideVelocity = _maxFall * _glideSpeedModifier * -jumpVelocity
	get:
		return _glideSpeedModifier
@onready var gravityGlide = calculate_gravity(jumpHeight, _jumpTimeToDescent / _glideSpeedModifier)
@onready var terminalGlideVelocity: int = _maxFall * _glideSpeedModifier * -jumpVelocity
@export_range(0.0 , 5.0, 0.01) var glideVelocityModifier: float = 0.6


#################################


func stat_update() -> void:
	pass
	#TOOD: check for upgraded stats


func calculate_tile_height(amount: float) -> float:
	return amount * Util.tileSize


func calculate_jump_velocity(height: float = jumpHeight):
	return -sqrt(2 * gravityJump * height)


func calculate_gravity(height: float = jumpHeight, time: float = _jumpTimeToPeak):
	return (2.0 * height) / pow(time, 2) 
