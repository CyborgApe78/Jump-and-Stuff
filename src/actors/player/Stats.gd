extends Node
class_name StatsComponent


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
@export var baseMove: float = 12:
	set(value):
		baseMove = value
		moveSpeed = calculate_tile_height(baseMove)
	get:
		return baseMove
## This value makes the time it takes to reach maximum speed smoother.
@export_range(0.0 , 2.0, 0.01) var baseAcceleration: float = 1.2
## The force applied to slow down the character's movement.
@export_range(0.0 , 1.0, 0.01) var baseFriction: float = 0.5
## Modulates the rate of horizontal speed decrease during airborne movement.
@export_range(0.0 , 2.0, 0.01) var baseAirMovement: float = 1.0
@onready var moveSpeed: int = calculate_tile_height(baseMove)
@onready var accelerationGround: float = moveSpeed / baseAcceleration
@onready var frictionGround: float = moveSpeed / baseFriction
@onready var accelerationAir: float = moveSpeed / (baseAcceleration * baseAirMovement)
@onready var frictionAir: float = moveSpeed / (baseFriction * baseAirMovement)


@export_group("Jump") #TODO: all other jumps
## Base Jump Height
@export var baseJumpHeight: float = 4.0: #LOOKAT: add 0.25 to just be over platform
	set(value):
		baseJumpHeight = value
		jumpHeight = calculate_tile_height(baseJumpHeight) #LOOKAT: should this be doubled since player is 2 blocks tall
		gravityJump = calculate_gravity()
		gravityFall = calculate_gravity(jumpHeight, jumpTimeToDescent)
		jumpVelocity = calculate_jump_velocity()
		jumpDoubleVelocity = calculate_jump_velocity(calculate_tile_height(baseJumpHeight * jumpDoubleModifier))
		jumpTripleVelocity = calculate_jump_velocity(calculate_tile_height(baseJumpHeight * jumpTripleModifier))
	get:
		return baseJumpHeight
## Time it takes to reach the maximum jump height
@export_range(0.0 , 1.0, 0.01) var jumpTimeToPeak: float = 0.5:
	set(value):
		jumpTimeToPeak = value
		gravityJump = calculate_gravity()
		jumpVelocity = calculate_jump_velocity()
		jumpDoubleVelocity = calculate_jump_velocity(calculate_tile_height(baseJumpHeight * jumpDoubleModifier))
		jumpTripleVelocity = calculate_jump_velocity(calculate_tile_height(baseJumpHeight * jumpTripleModifier))
	get:
		return jumpTimeToPeak
## Time it takes to reach the floor after jump
@export var jumpTimeToDescent: float = 0.25:
	set(value):
		jumpTimeToDescent = value
		gravityFall = calculate_gravity(jumpHeight, jumpTimeToDescent)
	get:
		return jumpTimeToDescent
@export var jumpTimeAtApex: float = 0.8:
	set(value):
		jumpTimeAtApex = value
		gravityFall = calculate_gravity(jumpHeight, jumpTimeAtApex)
	get:
		return jumpTimeAtApex
@export_range(0.0 , 5.0, 0.25) var jumpRunModifier: float = 1.0: 
	set(value):
		jumpRunModifier = value
		jumpRunVelocity = calculate_jump_velocity(calculate_tile_height(jumpRunModifier))
		jumpDoubleRunVelocity = calculate_jump_velocity(calculate_tile_height(baseJumpHeight + jumpDoubleModifier + jumpRunModifier))
		jumpTripleRunVelocity = calculate_jump_velocity(calculate_tile_height(baseJumpHeight + jumpTripleModifier + jumpRunModifier))
	get:
		return jumpRunModifier
@export_range(0.0 , 5.0, 0.25) var jumpDoubleModifier: float = 2.0:
	set(value):
		jumpDoubleModifier = value
		jumpDoubleVelocity = calculate_jump_velocity(calculate_tile_height(baseJumpHeight + jumpDoubleModifier))
		jumpDoubleRunVelocity = calculate_jump_velocity(calculate_tile_height(baseJumpHeight + jumpDoubleModifier + jumpRunModifier))
	get:
		return jumpDoubleModifier
@export_range(0.0 , 5.0, 0.25) var jumpTripleModifier: float = 4.0:
	set(value):
		jumpTripleModifier = value
		jumpTripleVelocity = calculate_jump_velocity(calculate_tile_height(baseJumpHeight + jumpTripleModifier))
		jumpTripleRunVelocity = calculate_jump_velocity(calculate_tile_height(baseJumpHeight + jumpTripleModifier + jumpRunModifier))
	get:
		return jumpTripleModifier

### The value represents a velocity threshold that determines whether the character can jump
#@export var jump_threshold: float = 300.0
### Jumps allowed to perform in a row
#@export var allowed_jumps : int = 1
### Reduced amount of jump effectiveness at each iteration
#@export var height_reduced_by_jump : int = 0
#
### Enable the coyote jump
#@export var coyote_jump_enabled: bool = true
### The time window this jump can be executed when the character is not on the floor
#@export var coyote_jump_time_window: float = 0.15

@onready var jumpHeight: int = calculate_tile_height(baseJumpHeight)
@onready var gravityJump: float = calculate_gravity(jumpHeight, jumpTimeToPeak)
@onready var gravityFall: float = calculate_gravity(jumpHeight, jumpTimeToDescent)
@onready var gravityApex: float = calculate_gravity(jumpHeight, jumpTimeAtApex)
@onready var jumpVelocity: float = calculate_jump_velocity()
@onready var jumpRunVelocity: float = calculate_jump_velocity(calculate_tile_height(baseJumpHeight + jumpRunModifier))
@onready var jumpDoubleVelocity: float = calculate_jump_velocity(calculate_tile_height(baseJumpHeight + jumpDoubleModifier))
@onready var jumpDoubleRunVelocity: float = calculate_jump_velocity(calculate_tile_height(baseJumpHeight + jumpDoubleModifier + jumpRunModifier))
@onready var jumpTripleVelocity: float = calculate_jump_velocity(calculate_tile_height(baseJumpHeight + jumpTripleModifier))
@onready var jumpTripleRunVelocity: float = calculate_jump_velocity(calculate_tile_height(baseJumpHeight + jumpTripleModifier + jumpRunModifier))
@onready var jumpFlipVelocity: float
@onready var jumpLongVelocity: float
@onready var jumpCrouchVelocity: float
@onready var jumpApexVelocity: float ##Lookat: needed?
@onready var jumpGroundPoundVelocity: float
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
@onready var dashSpeed: int = calculate_tile_height(baseDash)
##TODO: other categories

#################################

func  _ready() -> void:
	if baseStats:
		pass
		#TODO: resource for custom characters


func stat_update() -> void:
	pass
	#TOOD: check for upgraded stats


func calculate_tile_height(amount: int) -> int:
	return amount * Util.tileSize


func calculate_jump_velocity(height: int = jumpHeight, time: float = jumpTimeToPeak):
	return -sqrt(2 * gravityJump * height)


func calculate_gravity(height: int = jumpHeight, time: float = jumpTimeToPeak):
	return (2.0 * height) / pow(time, 2) 
