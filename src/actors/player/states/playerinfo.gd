extends PlayerState
class_name PlayerInfo


var stats: StatsComponent
var velocity: VelocityComponent
var input: InputComponent
var ground: GroundDetectorComponent
var wall: WallDetectorComponent
var abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")
var GameStats: Resource = preload("res://src/resources/gameStats.tres")
var CheckpointSystem: Resource = preload("res://src/resources/CheckpointSystem.tres")


var topSpeed: int ## keeps track of player speed for bonking

var dashBufferState: int




func gravity_logic(amount: float, delta) -> void:
	player.velocity.y += amount * delta


func apply_acceleration(speed: float, amount: float, delta: float) -> void:
	player.velocity.x = move_toward(abs(player.velocity.x), speed, amount * delta) * player.moveStrength.x


func apply_friction(amount: float, delta) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, amount * delta)


func momentum_logic(speed: float, useMoveDirection: bool) -> void:
	if useMoveDirection:
		if abs(player.velocity.x) < stats.moveSpeed:
			player.velocity.x = player.velocity.x
		else:
			player.velocity.x = player.moveDirection.x * max(abs(speed), abs(player.velocity.x))
	if !useMoveDirection:
		if abs(player.velocity.x) < stats.moveSpeed:
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


func speed_bend(forwardLean: bool = true, speed = stats.moveSpeed, leanAmount: float = 0.1) -> void: #FIXME: get this working
	#TODO: use animeation tree instead
	if forwardLean:
		player.characterRig.skew = remap(player.velocity.x, 0, speed, 0.0, leanAmount)
	if !forwardLean:
		player.characterRig.skew = remap(-player.velocity.x, 0, speed, 0.0, leanAmount)


func squash_and_stretch(delta): #FIXME: get this working
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
	if ground.groundAngle != player.rotation:
		player.rotation = ground.groundAngle


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


func dash_pressed_buffer() -> void:
#	var initial_direction = player.aimDirection.round()
	await get_tree().create_timer(0.1).timeout #FIXME: crash if not completed, look at buffer input timer
	dash_pressed_logic()
	await get_tree().create_timer(0.1).timeout
	dashBufferState = State.Null


func dash_pressed_logic() -> void:
	var dashInput: Vector2 = player.aimDirection if player.aimDirection != Vector2.ZERO else player.moveDirection
	
	if player.is_on_wall():
		if player.moveDirection.y == -1:
			dashBufferState = State.DashClimb
		else:
			dashBufferState = State.DashWall #TODO: remove and only from wallgrab
	elif dashInput.y == -1:
		dashBufferState = State.DashUp
	elif dashInput.y == 1:
		dashBufferState = State.DashDown
	elif player.is_on_floor():
		dashBufferState = State.DashGround
	elif !player.is_on_floor():
		dashBufferState = State.DashAir
	else:
		dashBufferState = State.Null
		EventBus.error.emit("null dash pressed logic")


func jump_logic(jumpHeight: int, runSpeed:int = stats.moveSpeed) -> void:
	if abs(player.velocity.x) > runSpeed:
		player.velocity.y = jumpHeight ## Add another tile height
