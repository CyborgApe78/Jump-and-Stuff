extends PlayerInfo

#LOOKAT: have to be at top speed?
#TODO: lock out of wall jump, until landed
@export var jumpModifier: float = 1.25


func enter() -> void:
	EventBus.emit_signal("actionAnnounce", "Boing")
	topSpeed = 0
	neutral_move_direction_logic()
	player.sounds.jump.pitch_scale = jumpModifier
	player.sounds.jump.play()
	player.particles.jumpDouble.restart()
	player.velocity.y = jumpVelocity * jumpModifier
	player.timers.coyoteJump.stop()
	player.timers.consecutiveJump.stop()
	player.jumpedDouble = true
	player.jumped = false


func exit() -> void:
	player.sounds.jump.pitch_scale = 1
	


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


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_released("jump"):
		player.velocity.y = max( player.velocity.y, jumpVelocity * percentMinJumpVelocity)
		if player.velocity.y > (jumpVelocity * jumpModifier) * percentKeepJumpConsecutive: ## needs to be a percent of full jump to keep it going
			consecutive_jump_cancel()
		return State.Fall
	if Input.is_action_just_pressed("glide")  and abilities.can_use_ability(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive")  and abilities.can_use_ability(PlayerAbilities.list.Dive):
		return State.Dive
	if Input.is_action_just_pressed("ground pound"):
		return State.GroundPound
	if Input.is_action_just_pressed("dash") and abilities.can_use_ability(abilities.list.DashSide):
		return State.DashAir

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_ceiling():
		consecutive_jump_cancel()
		return State.Fall
	if player.is_on_wall() and topSpeed > moveSpeed:
		topSpeed = 0
		return State.BonkAir
	if player.velocity.y > -jumpApexHeight:
		return State.JumpApex
	if player.is_on_floor():
		player.landed()
		if player.velocity.x != 0:
			return State.Walk
		else:
			return State.Idle

	return State.Null
