extends PlayerInfo


@export_group("Connections")
@export var timerCoyoteJumpWall: Timer
@export var timerLock: Timer
@export var particles: GPUParticles2D
@export var soundeffect: AudioStreamPlayer

@export_group("")

var jumpDirection: int


func enter() -> void:
	EventBus.playerJumped.emit()
	timerLock.start()
	jumpDirection = wall.wall_detection(30)
	
	input.neutral_move_direction_logic()
	player.animPlayer.queue("Jump")
	soundeffect.play()
	
	if !timerCoyoteJumpWall.is_stopped():
		jumpDirection = wall.lastWallDirection
		timerCoyoteJumpWall.stop()
		
	## up pressed or towards from wall pressed #TODO: turn into wall climb
	if (input.moveDirection.y == -1 or input.moveDirection.x == jumpDirection) and abilities.can_use(PlayerAbilities.list.JumpWallSame): 
		abilities.consume(PlayerAbilities.listUse.JumpWallSame, 1)
		player.facing_logic(wall.wallDirection)
		player.velocity = Vector2(10 * -jumpDirection, stats.jumpVelocity * 1.0)
	## down pressed
	elif input.moveDirection.y == 1:
		player.facing_logic(wall.wallDirection)
		player.velocity = Vector2(300 * -jumpDirection, 100)
	## no directional input
	elif input.moveDirection.x == 0:
		player.facing_logic(-wall.wallDirection)
		player.velocity = Vector2(max(stats.moveSpeed / 1.5 , abs(player.velocityPrevious.x)) * -jumpDirection, stats.jumpVelocity * 0.9)
	## away from wall pressed
	else:
		player.facing_logic(-wall.wallDirection)
		player.velocity = Vector2(stats.moveSpeed * -jumpDirection, stats.jumpVelocity * 0.7)
	
	particles.restart()
	velocity.topSpeed = 0


func exit() -> void:
	player.animPlayer.stop()


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(stats.jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(stats.jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide_rotation()
	if timerLock.is_stopped():
		if input.neutralMoveDirection:
			neutral_air_momentum_logic(stats.moveSpeed)
		else:
			velocity.air_velocity_logic(stats.moveSpeed, stats.accelerationAir, stats.frictionAir, delta)
	velocity.gravity_logic(stats.gravityJump, delta)
	
	velocity.track_top_speed(player.velocity.x)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if timerLock.is_stopped():
		if input.justReleasedJump:
			player.velocity.y = max(player.velocity.y, stats.jumpVelocity * stats.percentMinJumpVelocity)
			return State.Fall
		if input.justPressedGlide and abilities.can_use(PlayerAbilities.list.Glide):
			return State.Glide
		if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Dive):
			return State.Dive
		if input.justPressedCrouch and abilities.can_use(PlayerAbilities.list.GroundPound): 
			return State.GroundPound
		if input.justPressedDash:
			dash_pressed_buffer()
		if input.justPressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
			return State.GrappleHook
		if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
			return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if timerLock.is_stopped():
		if player.is_on_ceiling():
			consecutive_jump_cancel()
#			if abilities.can_use(PlayerAbilities.list.CeilingRun):
#				return State.CeilingRun #TODO: add
#			else:
			return State.Fall
		if player.is_on_wall() and velocity.topSpeed > stats.moveSpeed:
			velocity.topSpeed = 0
			return State.BonkAir
		if player.velocity.y > -stats.jumpApexHeight:
			return State.JumpApex
		if player.is_on_floor():
			player.landed()
			EventBus.rumble.emit(0.1, 0.2, 0.2)
			if player.velocity.x != 0:
				return State.Walk
			else:
				return State.Idle
		if dashBufferState != State.Null:
			if dashBufferState == State.DashAir and abilities.can_use(PlayerAbilities.list.DashSide):
				return State.DashAir
			if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
				return State.DashUp
			if dashBufferState == State.DashDown and abilities.can_use(PlayerAbilities.list.DashDown):
				return State.DashDown

	return State.Null
