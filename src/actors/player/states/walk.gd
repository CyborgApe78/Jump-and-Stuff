extends PlayerInfo

#TODO: add nuetral input

@export_group("Connections")
@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var soundeffect: AudioStreamPlayer

@export_group("")
@export var skidPercent: float = 1.2

var skidding: bool = false


func enter() -> void:
	player.animPlayer.queue("Walk")
	skidding = false


func exit() -> void:
	player.animPlayer.stop()
	soundeffect.pitch_scale = 1
	player.animPlayer.speed_scale = 1


func physics(delta) -> void:
	player.move_and_slide()
	if abs(player.velocity.x) > stats.moveSpeed * skidPercent and input.moveDirection.x != 0 and (sign(player.velocity.x) != input.moveDirection.x):
		skidding = true
	elif player.velocity.x != 0 and sign(player.velocity.x) != input.lastMoveDirection.x: ## kill velocity when changing directions
		player.velocity.x = input.lastMoveDirection.x * 1
	elif input.moveDirection.x != 0 and abs(player.velocity.x) < stats.moveSpeed:
		velocity.apply_acceleration(stats.moveSpeed, stats.accelerationGround, delta)
	elif input.moveDirection.x == 0:
		velocity.apply_friction(stats.frictionGround, delta)
	elif abs(player.velocity.x) >= stats.moveSpeed:
		velocity.momentum_logic(stats.moveSpeed, true)
	
	if input.moveDirection.x == 0 and ((player.facing == -1 and ground.ledgeLeft) or (player.facing == 1 and ground.ledgeRight)): ## stops on ledge w/o input
		player.velocity.x = 0
		EventBus.helperUsed.emit(Util.helper.stopOnLedge)


func visual(delta) -> void:
	player.animation_speed(.004)
	player.facing_logic(input.lastMoveDirection.x)
	speed_bend(false)
	align_to_ground()


func sound(delta: float) -> void:
	if !soundeffect.playing:
		soundeffect.pitch_scale = randf_range(0.9, 1.1)


func handle_input(event: InputEvent) -> int:
	if input.justPressedJump:
		return consecutive_jump_logic()
	if input.justPressedDash:
		dash_pressed_buffer()
	if input.justPressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if input.pressedCrouch: 
		return State.Crouch
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
		if input.pressedCrouch and abilities.can_use(PlayerAbilities.list.JumpLong): ## not sure if do anything since long jump checks for this
			return State.JumpLong
		else:
			return consecutive_jump_logic()
	if dashBufferState != State.Null:
		if dashBufferState == State.DashGround and abilities.can_use(PlayerAbilities.list.DashSide):
			return State.DashGround
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			return State.DashUp

	return State.Null

