extends PlayerInfo


@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var soundeffect: AudioStreamPlayer

var skidding: bool = false
@export var speedModifier: float = 2.5
var pMoveSpeed: float


func enter() -> void:
	pMoveSpeed = stats.moveSpeed
	stats.moveSpeed = stats.moveSpeed * speedModifier
	player.animPlayer.queue("Walk")
	skidding = false


func exit() -> void:
	stats.moveSpeed = pMoveSpeed
	player.animPlayer.stop()
	soundeffect.stop()
	player.animPlayer.speed_scale = 1


func physics(delta) -> void:
	player.move_and_slide()
	if abs(player.velocity.x) > pMoveSpeed and input.moveDirection.x != 0 and (sign(player.velocity.x) != input.moveDirection.x):
		skidding = true
	elif input.moveDirection.x != 0 and abs(player.velocity.x) < stats.moveSpeed:
		velocity.apply_acceleration(stats.moveSpeed, stats.accelerationGround, delta)
	elif input.moveDirection.x == 0:
		velocity.apply_friction(stats.frictionGround, delta)
	elif abs(player.velocity.x) >= stats.moveSpeed:
		velocity.momentum_logic(stats.moveSpeed, true)
	
	if input.moveDirection.x == 0 and (ground.ledgeLeft or ground.ledgeRight): ## stops on ledge w/o input
		player.velocity.x = move_toward(player.velocity.x, 0, stats.frictionGround)
		EventBus.helperUsed.emit(Util.helper.stopOnLedge)


func visual(delta) -> void:
	player.animation_speed(0.004)
	player.facing_logic(input.moveDirection.x)
	speed_bend(false)
	align_to_ground()


func sound(delta: float) -> void:
		pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_pressed("store_boost"): 
		pass
	if input.justPressedJump:
		return consecutive_jump_logic()
	if input.justPressedDash and abilities.can_use(PlayerAbilities.list.DashSide):
		if player.is_on_floor():
			return State.DashGround
		else:
			return State.DashAir
	if input.justPressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if skidding:
		return State.Skid
	if !player.is_on_floor():
		timerCoyoteJump.start()
		return State.Fall
	if player.velocity.x == 0:
		return State.Idle
	if !timerBufferJump.is_stopped():
		timerBufferJump.stop()
		EventBus.helperUsed.emit(Util.helper.bufferJump)
		return consecutive_jump_logic()

	return State.Null

