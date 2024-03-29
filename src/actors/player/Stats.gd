extends Node
class_name StatsComponent
#TODO: add all variables to dependent set/get

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
@export_range(0.0 , 2.0, 0.01) var _baseAcceleration: float = 1.2
## The force applied to slow down the character's movement.
@export_range(0.0 , 1.0, 0.01) var _baseFriction: float = 0.5
## Modulates the rate of horizontal speed decrease during airborne movement.
@export_range(0.0 , 2.0, 0.01) var baseAirMovement: float = 1.0 #LOOKAT: remove

@onready var moveSpeed: int = calculate_tile_height(_baseMove)
@onready var accelerationGround: float = moveSpeed / _baseAcceleration
@onready var frictionGround: float = moveSpeed / _baseFriction
@onready var accelerationAir: float = moveSpeed / (_baseAcceleration * baseAirMovement)
@onready var frictionAir: float = moveSpeed / (_baseFriction * baseAirMovement)

@export_group("Crouch")
@export_range(0.0 , 2.0, 0.01) var _basefrictionCrouch: float = 0.8
@export_range(0.0 , 5.0, 0.01) var crouchVelocityModifier: float = 0.1
@export_range(0.0 , 5.0, 0.01) var crouchSpeedModifier: float = 0.25
@export_range(0.0 , 5.0, 0.01) var crouchChargedSpeedModifier: float = 0.5
@export var minLongJumpVelocity: int = 200
@export_range(0.0 , 2.0, 0.05) var timeCrouchCharge: float = 1.0

@onready var frictionCrouch: float = moveSpeed / _basefrictionCrouch #TODO: check for set/get for onready funcs

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


@export_group("Wall Jump")
@export_range(0.0 , 5.0, 0.05) var _wallJumpUpModifier: float = 1.0:
	set(value):
		_wallJumpUpModifier = value
		wallJumpUpVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_wallJumpUpModifier))
	get:
		return _wallJumpUpModifier
@export_range(0.0 , 5.0, 0.05) var _wallJumpDownModifier: float = 1.0:
	set(value):
		_wallJumpDownModifier = value
		wallJumpUpVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_wallJumpDownModifier))
	get:
		return _wallJumpDownModifier
@export_range(0.0 , 5.0, 0.05) var _wallJumpNeutralModifier: float = 1.0:
	set(value):
		_wallJumpNeutralModifier = value
		wallJumpUpVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_wallJumpNeutralModifier))
	get:
		return _wallJumpNeutralModifier
@export_range(0.0 , 5.0, 0.05) var _wallJumpAwayModifier: float = 1.0:
	set(value):
		_wallJumpAwayModifier = value
		wallJumpUpVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_wallJumpAwayModifier))
	get:
		return _wallJumpAwayModifier
@export_range(0.0 , 5.0, 0.05) var _wallJumpTowardModifier: float = 1.0:
	set(value):
		_wallJumpTowardModifier = value
		wallJumpUpVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_wallJumpTowardModifier))
	get:
		return _wallJumpTowardModifier
@onready var wallJumpUpVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_wallJumpUpModifier))
@onready var wallJumpDownVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_wallJumpDownModifier))
@onready var wallJumpAwayVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_wallJumpNeutralModifier))
@onready var wallJumpTowardVelocity = calculate_jump_velocity(jumpHeight + calculate_tile_height(_wallJumpTowardModifier))
#TODO: wall jump speed
#if input.moveDirection.y == -1:
#		player.velocity = Vector2(100 * -jumpDirection, stats.jumpVelocity * 1.0)
#	## down pressed
#	elif input.moveDirection.y == 1:
#		player.velocity = Vector2(300 * -jumpDirection, 100)
#	## no directional input
#	elif input.moveDirection.x == 0:
#		player.velocity = Vector2(max(stats.moveSpeed / 1.5 , abs(player.velocityPrevious.x)) * -jumpDirection, stats.jumpVelocity * 0.9)
#	## away from wall pressed
#	elif input.moveDirection.x == -jumpDirection:
#		player.velocity = Vector2(stats.moveSpeed * -jumpDirection, stats.jumpVelocity * 0.7)
#	## towards from wall pressed
#	elif input.moveDirection.x == jumpDirection: ) 
#		player.velocity = Vector2(200 * -jumpDirection, stats.jumpVelocity * 0.8)

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

@export_group("Dive")
@export var _baseDiveHeight: float = 2.0:
	set(value):
		_baseDiveHeight = value
		gpVelocity = calculate_jump_velocity(calculate_tile_height(_baseDiveHeight + _jumpHeightPlatformBoost), _gpTimeToPeak)
	get:
		return _baseDiveHeight
@export_range(0.0 , 1.0, 0.05) var _diveTimeToPeak: float = 0.1:
	set(value):
		_diveTimeToPeak = value
		gpVelocity = calculate_jump_velocity(calculate_tile_height(_baseDiveHeight + _jumpHeightPlatformBoost), _diveTimeToPeak)
	get:
		return _diveTimeToPeak
@onready var diveVelocity: float = calculate_jump_velocity(calculate_tile_height(_baseDiveHeight + _jumpHeightPlatformBoost), _diveTimeToPeak)
@export_range(0.0 , 5.0, 0.05) var _diveFloatModifier: float = 0.5:
	set(value):
		_diveFloatModifier = value
		gravityDiveFloat = calculate_gravity(jumpHeight, _jumpTimeToDescent / _diveFloatModifier)
	get:
		return _diveFloatModifier
@onready var gravityDiveFloat = calculate_gravity(jumpHeight, _jumpTimeToDescent / _diveFloatModifier)
@export var diveSpeedMultiplier: float = 1.6
@export var multiplierGroundPound: float = 1.5

@export_group("Slide")
var upHillFrictionModifier: float = 2.0
var flatGroundFrictionModifier: float = 1.75 #TODO: these need to move to state using them. slide/roll have different values
var downHillAccel: float = 50
@export var jumpModifier: float = 0.25
@export var slidevelocityModifier: float = 1.0
var velocityHop: float

@export_group("Wall Slide")
var wallSlideFriction #TODO:
var downpressedFriction

@export_group("Dash")
@export var _baseDash: float = 36:
	set(value):
		_baseDash = value
		dashSpeed = calculate_tile_height(_baseDash)
	get:
		return _baseDash
@onready var dashSpeed: int = calculate_tile_height(_baseDash) #TODO: change to velocity

@export_group("GroundPound")
@export var _baseGPHeight: float = 1.0:
	set(value):
		_baseGPHeight = value
		gpVelocity = calculate_jump_velocity(calculate_tile_height(_baseGPHeight + _jumpHeightPlatformBoost), _gpTimeToPeak)
	get:
		return _baseGPHeight
@export_range(0.0 , 1.0, 0.05) var _gpTimeToPeak: float = 0.2:
	set(value):
		_gpTimeToPeak = value
		gpVelocity = calculate_jump_velocity(calculate_tile_height(_baseGPHeight + _jumpHeightPlatformBoost), _gpTimeToPeak)
	get:
		return _gpTimeToPeak
@onready var gpVelocity: float = calculate_jump_velocity(calculate_tile_height(_baseGPHeight + _jumpHeightPlatformBoost), _gpTimeToPeak)
@export_range(0.0 , 5.0, 0.05) var _gpModifier: float = 1.5:
	set(value):
		_gpModifier = value
		gravityGP = calculate_gravity(jumpHeight, _jumpTimeToDescent / _gpModifier)
		gravityGPFloat = calculate_gravity(jumpHeight, _jumpTimeToDescent / (_gpModifier / _gpFloatModifier))
		terminalGPVelocity = _maxFall * _gpModifier * -jumpVelocity
	get:
		return _gpModifier
@export_range(0.0 , 5.0, 0.05) var _gpFloatModifier: float = 3:
	set(value):
		_gpFloatModifier = value
		gravityGPFloat = calculate_gravity(jumpHeight, _jumpTimeToDescent / (_gpModifier / _gpFloatModifier))
	get:
		return _gpFloatModifier
@onready var gravityGP = calculate_gravity(jumpHeight, _jumpTimeToDescent / _gpModifier)
@onready var gravityGPFloat = calculate_gravity(jumpHeight, _jumpTimeToDescent / (_gpModifier / _gpFloatModifier))
@onready var terminalGPVelocity: int = _maxFall * _gpModifier * -jumpVelocity

@export_group("Grapple")
@export var _baseGrapple: float = 36:
	set(value):
		_baseGrapple = value
		grappleSpeed = calculate_tile_height(_baseGrapple)
	get:
		return _baseGrapple
@onready var grappleSpeed: int = calculate_tile_height(_baseGrapple)

@export_group("Bash")

@export_group("Spin")
@export var _baseSpinHeight: float = 1.0:
	set(value):
		_baseSpinHeight = value
		jumpHeight = calculate_tile_height(_baseSpinHeight + _jumpHeightPlatformBoost)
	get:
		return _baseSpinHeight
@onready var spinHeight: int = calculate_tile_height(_baseSpinHeight + _jumpHeightPlatformBoost)

@export_group("Roll")
@export_range(0.0 , 5.0, 0.01) var rollVelocityModifier: float = 1.25
@export_range(0.0 , 5.0, 0.01) var rollChainVelocityModifier: float = 1.5
@export_range(0.0 , 5.0, 0.01) var rollJumpVelocityModifier: float = 1.75
@export_range(0.0 , 5.0, 0.01) var rollDashVelocityModifier: float = 1.25
@export_range(0.0 , 2.0, 0.01) var _basefrictionRoll: float = 0.6:
	set(v):
		frictionRoll = moveSpeed * rollVelocityModifier / v
	get:
		return _basefrictionRoll
@export_range(0.0 , 5.0, 0.01) var _baseRollDownHillAccel: float = 0.6:
	set(v):
		rollDownHillAccel = moveSpeed * rollVelocityModifier / v
	get:
		return _baseRollDownHillAccel

@onready var frictionRoll: float = moveSpeed * rollVelocityModifier / _basefrictionRoll
@onready var rollDownHillAccel: float = moveSpeed * rollVelocityModifier / _baseRollDownHillAccel

@export_group("Swim")
@export_range(0.0 , 5.0, 0.01) var swimVelocityModifier: float = 1.0


@export_group("Burrow")

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
