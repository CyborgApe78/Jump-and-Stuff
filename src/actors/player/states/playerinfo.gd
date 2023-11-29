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

var dashBufferState: int


func speed_bend(forwardLean: bool = true, speed = stats.moveSpeed, leanAmount: float = 0.2) -> void:
	if forwardLean:
		player.characterSAS.skew = remap(player.facing * abs(player.velocity.x), 0, speed, 0.0, player.facing * leanAmount)
	if !forwardLean:
		player.characterSAS.skew = remap(player.velocity.x, 0, speed, 0.0, -player.facing * leanAmount)


func consecutive_jump_logic() -> int:
	if abilities.can_use(PlayerAbilities.list.JumpConsec) and player.jumped:
		return State.JumpConsec
	else:
		return State.Jump


func consecutive_jump_cancel() -> void: 
	player.jumped = false
	player.timers.consecutiveJump.stop()
	abilities.reset(PlayerAbilities.listChain.JumpConsec)


func align_to_ground()-> void:
	if ground.groundAngle != player.rotation:
		player.rotation = ground.groundAngle


func dash_pressed_buffer() -> void:
	await get_tree().create_timer(0.1).timeout #FIXME: crash if not completed, look at buffer input timer
	dash_pressed_logic()
	await get_tree().create_timer(0.1).timeout
	dashBufferState = State.Null


func dash_pressed_logic() -> void:
	if player.is_on_wall():
		if input.aimBackup.y == -1:
			dashBufferState = State.DashClimb
		else:
			dashBufferState = State.DashWall
	elif input.aimBackup.y == -1:
		dashBufferState = State.DashUp
	elif input.aimBackup.y == 1:
		dashBufferState = State.DashDown
	elif player.is_on_floor():
		dashBufferState = State.DashGround
	elif !player.is_on_floor():
		dashBufferState = State.DashAir
	else:
		dashBufferState = State.Null
		EventBus.error.emit("null dash pressed logic")


func neutral_air_momentum_logic(speed) -> void:
	if input.moveDirection.x != 0 and input.neutralMoveDirection: ## Cancel out neutral momentum
		input.neutralMoveDirection = false


func jump_logic(jumpHeight: int, runSpeed:int = stats.moveSpeed) -> void:
	if abs(player.velocity.x) > runSpeed:
		player.velocity.y = jumpHeight ## Add another tile height
