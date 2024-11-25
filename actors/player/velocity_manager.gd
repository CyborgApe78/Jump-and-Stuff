class_name VelocityManager extends Node


@export var stats: StatsManager
#@export var abilities: PlayerAbilities
#@export var ground: GroundDetectorComponent
@export var input: InputManager

@onready var player = get_parent() as CharacterBody2D

#var velocity: Vector2 = Vector2.ZERO

var groundAngle: float #TODO: own component
var velocityPrevious: Vector2 = Vector2.ZERO
var velocityRotated: Vector2 = Vector2.ZERO
var GPMaxVelocity: Vector2 = Vector2.ZERO

#var targetGrapple: TargetGrapple #TODO: own component
#var targetBash: TargetBash

var wallDirection: int = 0 
var lastWallDirection: int = 0
var facing: int = 1

var jumped: bool
var ledgeLeft: bool #TODO: own component
var ledgeRight: bool

var bounceVelocity: Vector2

var topSpeed: int ## keeps track of player speed for bonking


func move() -> void:
#	player.velocity = velocity
	player.move_and_slide()

func move_and_rotate() -> void:
#	player.velocity = velocity
	player.move_and_slide()



func gravity_logic(amount: float, delta) -> void:
	player.velocity.y += amount * delta


func apply_acceleration(speed: float, amount: float, delta: float) -> void:
	player.velocity.x = move_toward(abs(player.velocity.x), speed, amount * delta) * input.moveStrength.x


func apply_friction(amount: float, delta) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, amount * delta)


func momentum_logic(speed: float, useMoveDirection: bool) -> void:
	if useMoveDirection:
		if abs(player.velocity.x) < stats.moveSpeed:
			player.velocity.x = player.velocity.x
		else:
			player.velocity.x = input.moveDirection.x * max(abs(speed), abs(player.velocity.x))
	if !useMoveDirection:
		if abs(player.velocity.x) < stats.moveSpeed:
			player.velocity.x = player.velocity.x
		else:
			player.velocity.x = max(abs(speed), abs(player.velocity.x)) * player.facing


func air_velocity_logic(speed: float, acceleration: float, friction: float, delta: float) -> void:
	if player.velocity.x != 0 and input.moveDirection.x != 0 and (sign(player.velocity.x) != input.moveDirection.x):
		player.velocity.x = input.lastMoveDirection.x * 1
	else:
		if player.velocity.x != 0 and sign(player.velocity.x) != input.lastMoveDirection.x:
			player.velocity.x = input.lastMoveDirection.x * 1
		elif input.moveDirection.x != 0 and abs(player.velocity.x) < speed:
			apply_acceleration(speed, acceleration, delta)
		elif input.moveDirection.x == 0:
			apply_friction(friction, delta)
		elif abs(player.velocity.x) >= speed:
			momentum_logic(speed, true)


func fall_speed_logic(amount) -> void:
	player.velocity.y = min(player.velocity.y, amount)


func track_top_speed(speed:int) -> void: #TODO: change to bool return
	if abs(player.velocity.x) > topSpeed:
		topSpeed = abs(speed)


func jump_logic(jumpHeight: int, runSpeed:int = stats.moveSpeed) -> void: #TODO: change to value return
	if abs(player.velocity.x) > runSpeed:
		player.velocity.y = jumpHeight ## Add another tile height
