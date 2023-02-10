extends PlayerInfo


func enter() -> void:
	EventBus.actionAnnounce.emit("Boing")
	topSpeed = 0
	neutral_move_direction_logic()
	player.particles.jump.restart()
	player.sounds.jump.play()
	player.velocity.y = jumpVelocity
	player.timers.coyoteJump.stop()
	player.timers.consecutiveJump.stop()
	player.jumped = true


func exit() -> void:
	pass


func physics(delta) -> void:
	
	player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide_rotation()
	
	gravity_logic(gravityJump, delta)
	
	if player.neutralMoveDirection:
		neutral_air_momentum_logic(moveSpeed)
	else:
		air_velocity_logic(moveSpeed, accelerationAir, frictionAir, delta)
	
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	squash_and_stretch(delta)


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_released("jump"):
		player.velocity.y = max( player.velocity.y, jumpVelocity * percentMinJumpVelocity)
		if player.velocity.y > jumpVelocity * percentKeepJumpConsecutive: ## needs to be a percent of full jump to keep it going
			consecutive_jump_cancel()
		return State.Fall
	if Input.is_action_just_pressed("glide")  and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive")  and abilities.can_use(PlayerAbilities.list.Dive):
		return State.Dive
	if Input.is_action_just_pressed("crouch") and abilities.can_use(PlayerAbilities.list.GroundPound):
			return State.GroundPound
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_ceiling():
		consecutive_jump_cancel()
		return State.Fall
	if player.is_on_wall():
		if topSpeed > moveSpeed:
			topSpeed = 0
			return State.BonkAir
		else:
			return State.WallLand
	if player.velocity.y > -jumpApexHeight:
		return State.JumpApex
	if player.is_on_floor():
		player.landed()
		if player.velocity.x != 0:
			return State.Walk
		else:
			return State.Idle
	if dashBufferState != State.Null:
		if abilities.can_use(PlayerAbilities.list.DashSide) and dashBufferState == State.DashAir:
			dashBufferState = State.Null
			return State.DashAir
		if abilities.can_use(PlayerAbilities.list.DashUp) and dashBufferState == State.DashUp:
			dashBufferState = State.Null
			return State.DashUp
		if abilities.can_use(PlayerAbilities.list.DashDown) and dashBufferState == State.DashDown:
			dashBufferState = State.Null
			return State.DashDown

	return State.Null
