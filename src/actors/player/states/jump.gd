extends PlayerInfo


func enter() -> void:
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
	#LOOKAT: move to func
	if player.test_move(player.global_transform, Vector2(0, player.velocity.y * delta)):
		player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	
	if player.test_move(player.global_transform, Vector2(player.velocity.x * delta, 0)): #FIXME: need to check if angled ceiling and cancel
		player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
		
	gravity_logic(gravityJump, delta)
	track_top_speed()
	
	if player.neutralMoveDirection:
		neutral_air_momentum_logic(moveSpeed)
	else:
		air_velocity_logic(moveSpeed, accelerationAir, frictionAir)
		
	player.set_up_direction(-player.transform.y)
	player.velocity = player.velocity.rotated(player.rotation)
	player.move_and_slide()
	player.velocity = player.velocity.rotated(-player.rotation)


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
	if Input.is_action_just_pressed("dive"):
		return State.Dive

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall() and topSpeed > moveSpeed:
		topSpeed = 0
		return State.BonkAir
	if player.velocity.y > -jumpApexHeight:
		return State.JumpApex
	if player.is_on_floor():
		if player.velocity.x != 0:
			return State.Walk
		else:
			return State.Idle
	if player.is_on_ceiling():
		consecutive_jump_cancel()
		return State.Fall

	return State.Null
