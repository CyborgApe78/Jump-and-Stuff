extends PlayerInfo


@export var jumpModifier: float = 0.25
@export var particles: GPUParticles2D


func enter() -> void:
	GameStats.jumps += 1
	abilities.consume(PlayerAbilities.list.JumpConsec, 1)
	EventBus.actionAnnounce.emit("Boing")
	topSpeed = 0
	neutral_move_direction_logic()
	player.animPlayer.queue("Jump")
	player.sounds.jump.pitch_scale = 0.25 * abilities.currentJumpConsec + 1
	player.sounds.jump.play()
	particles.restart() #TODO: adjust based on consec number
	player.velocity.y = jumpVelocity * ((jumpModifier * abilities.currentJumpConsec) + 1)
	player.timers.coyoteJump.stop()
	player.timers.consecutiveJump.stop()
	
	if abilities.currentJumpConsec > 1: #TODO: move to animation
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
		tween.tween_property(player.characterRotate,"rotation", player.facing * abilities.currentJumpConsec * PI, 0.5) ## flip,
		tween.tween_property(player.characterCollision,"rotation", player.facing * abilities.currentJumpConsec * PI, 0.5) #FIXME: leaves upside down on odd numbers


func exit() -> void:
	player.animPlayer.stop()
	player.sounds.jump.pitch_scale = 1
	player.characterRotate.rotation_degrees = 0 
	player.characterCollision.rotation_degrees = 0
	if abilities.currentJumpConsec == abilities.maxJumpConsec:
		abilities.reset(PlayerAbilities.list.JumpConsec)
		player.jumped = false


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	gravity_logic(gravityJump, delta)
	
	if player.neutralMoveDirection:
		neutral_air_momentum_logic(moveSpeed)
	else:
		air_velocity_logic(moveSpeed, accelerationAir, frictionAir, delta)
	
	player.move_and_slide_rotation()
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	squash_and_stretch(delta)
	player.facing_logic()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_released("jump"):
		player.velocity.y = max( player.velocity.y, jumpVelocity * percentMinJumpVelocity)
		if player.velocity.y > (jumpVelocity * ((jumpModifier * abilities.currentJumpConsec) + 1)) * percentKeepJumpConsecutive: ## needs to be a percent of full jump to keep it going
			consecutive_jump_cancel()
		return State.Fall
	if Input.is_action_just_pressed("glide")  and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive")  and abilities.can_use(PlayerAbilities.list.Dive):
		return State.Dive
	if Input.is_action_just_pressed("ground pound") and abilities.can_use(PlayerAbilities.list.GroundPound):
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
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashAir
		if abilities.can_use(PlayerAbilities.list.DashUp) and dashBufferState == State.DashUp:
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashUp
		if abilities.can_use(PlayerAbilities.list.DashDown) and dashBufferState == State.DashDown:
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashDown

	return State.Null
