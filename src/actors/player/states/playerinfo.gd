extends PlayerState
class_name PlayerInfo


var stats: Resource = preload("res://src/actors/player/resources/playerStats.tres")
var abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")
var GameStats: Resource = preload("res://src/resources/gameStats.tres")
var CheckpointSystem: Resource = preload("res://src/resources/CheckpointSystem.tres")

var moveSpeed: int
var jumpVelocity: float
var gravityJump: float
var gravityFall: float
var gravityApex: float
var dashVelocity: float
var accelerationGround: float
var frictionGround: float
var accelerationAir: float
var frictionAir: float
var terminalVelocity: int

var jumpApexHeight: float = 40
var jumpCornerCorrectionVertical: int = 10
var jumpCornerCorrectionHorizontal: int = 15
var percentMinJumpVelocity: float = 0.8
var percentKeepJumpConsecutive: float = 0.9
var airTurnModifier: float = 4.0
var upHillFrictionModifier: float = 2.0
var flatGroundFrictionModifier: float = 1.75 #TODO: these need to move to state using them. slide/roll have different values
var downHillAccel: float = 50

var topSpeed: int ## keeps track of player speed for bonking

func _ready() -> void:
	EventBus.playerStatsCheck.connect(update_stats)

func update_stats() -> void:
	#TODO: create setget
	var jumpHeight: float
	var jumpTimeToPeak: float = 0.5
	var jumpTimeToDescent: float = 0.25
	var jumpTimeAtApex: float = 0.8
	
	moveSpeed = stats.baseSpeed * Util.tileSize
	accelerationGround = moveSpeed / stats.baseAcceleration
	frictionGround = moveSpeed / stats.baseFriction
	accelerationAir = moveSpeed / (stats.baseAcceleration * stats.airModifier)
	frictionAir = moveSpeed / (stats.baseFriction * stats.airModifier)
	dashVelocity = moveSpeed * 3
	
	jumpHeight = stats.baseJumpHeight * Util.tileSize
	gravityJump = 2 * jumpHeight / pow(jumpTimeToPeak, 2)
	gravityFall = 2 * jumpHeight / pow(jumpTimeToDescent, 2)
	gravityApex = 2 * jumpHeight / pow(jumpTimeAtApex, 2)
	jumpVelocity = -sqrt(2 * gravityJump * jumpHeight)
	
	terminalVelocity = -jumpVelocity * stats.terminalVelocityModifier
	
	abilities.reset(PlayerAbilities.list.All)


func gravity_logic(amount: float, delta) -> void:
	player.velocity.y += amount * delta


func apply_acceleration(speed: float, amount: float, delta: float) -> void:
	player.velocity.x = move_toward(abs(player.velocity.x), speed, amount * delta) * player.moveStrength.x


func apply_friction(amount: float, delta) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, amount * delta)


func momentum_logic(speed: float, useMoveDirection: bool) -> void:
	if useMoveDirection:
		if abs(player.velocity.x) < moveSpeed:
			player.velocity.x = player.velocity.x
		else:
			player.velocity.x = player.moveDirection.x * max(abs(speed), abs(player.velocity.x))
	if !useMoveDirection:
		if abs(player.velocity.x) < moveSpeed:
			player.velocity.x = player.velocity.x
		else:
			player.velocity.x = max(abs(speed), abs(player.velocity.x)) * player.facing


func air_velocity_logic(speed: float, acceleration: float, friction: float, delta: float) -> void:
	if player.velocity.x != 0 and player.moveDirection.x != 0 and (sign(player.velocity.x) != player.moveDirection.x):
		player.velocity.x = player.lastMoveDirection.x * 1
	else:
		if player.velocity.x != 0 and sign(player.velocity.x) != player.lastMoveDirection.x:
			player.velocity.x = player.lastMoveDirection.x * 1
		elif player.moveDirection.x != 0 and abs(player.velocity.x) < speed:
			apply_acceleration(speed, acceleration, delta)
		elif player.moveDirection.x == 0:
			apply_friction(friction, delta)
		elif abs(player.velocity.x) >= speed:
			momentum_logic(speed, true)


func fall_speed_logic(amount) -> void:
	player.velocity.y = min(player.velocity.y, amount)


func speed_bend(forwardLean: bool = true, speed = moveSpeed, leanAmount: float = 0.1) -> void:
	#TODO: use animeation tree instead
	if forwardLean:
		player.characterRig.skew = remap(player.velocity.x, 0, speed, 0.0, leanAmount)
	if !forwardLean:
		player.characterRig.skew = remap(-player.velocity.x, 0, speed, 0.0, leanAmount)


func squash_and_stretch(delta):
	#TODO: use animeation tree instead
#	if !player.is_on_floor():
#		player.characterRig.scale.y = remap(abs(player.velocity.y), 0, abs(jumpVelocity), 0.75, 1.25)
#		player.characterRig.scale.x = remap(abs(player.velocity.y), 0, abs(jumpVelocity), 1.25, 0.75)
#
#	player.characterRig.scale.x = lerp(player.characterRig.scale.x, 1.0, 1.0 - pow(0.01, delta))
#	player.characterRig.scale.y = lerp(player.characterRig.scale.y, 1.0, 1.0 - pow(0.01, delta))
	pass


func consecutive_jump_logic() -> int:
	if abilities.can_use(PlayerAbilities.list.JumpConsec) and player.jumped:
		return State.JumpConsec
	else:
		return State.Jump


func consecutive_jump_cancel() -> void: 
	player.jumped = false
	player.timers.consecutiveJump.stop() #TODO:find a better to cancel timer
	abilities.reset(PlayerAbilities.list.JumpConsec)


func align_to_ground()-> void:
	if player.groundAngle != 0:
		player.rotation = player.groundAngle


func neutral_move_direction_logic() -> void:
	if player.moveDirection == Vector2.ZERO:
		player.neutralMoveDirection = true
	else:
		player.neutralMoveDirection = false


func neutral_air_momentum_logic(speed) -> void:
	if player.moveDirection.x != 0 and player.neutralMoveDirection: ## Cancel out neutral momentum
		player.neutralMoveDirection = false


func track_top_speed(speed:int) -> void:
	if abs(player.velocity.x) > topSpeed:
		topSpeed = abs(speed)
