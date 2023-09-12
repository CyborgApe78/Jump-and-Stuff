extends PlayerInfo

#TODO: higher jump at faster speed

@export var timerCoyoteJump: Timer
@export var timerConsecutiveJump: Timer
@export var soundeffect: AudioStreamPlayer


func enter() -> void:
	EventBus.playerJumped.emit()
	topSpeed = 0
	neutral_move_direction_logic()
	player.animPlayer.queue("Jump")
	soundeffect.play()
	
	if abs(player.velocity.x) > stats.moveSpeed: #TODO: make higher jump for moving fast
		player.velocity.y = stats.jumpVelocity
	player.velocity.y = stats.jumpVelocity
	timers()
	player.jumped = true


func exit() -> void:
	player.animPlayer.stop()


func physics(delta) -> void:
	
	player.attempt_horizontal_corner_correction(stats.jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(stats.jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide_rotation()
	
	gravity_logic(stats.gravityJump, delta)
	
	if player.neutralMoveDirection:
		neutral_air_momentum_logic(stats.moveSpeed)
	else:
		air_velocity_logic(stats.moveSpeed, stats.accelerationAir, stats.frictionAir, delta)
	
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	squash_and_stretch(delta)
	player.facing_logic()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justReleasedJump: #LOOKAT: cutting in half instead of instant
		player.velocity.y = max(player.velocity.y, stats.jumpVelocity * stats.percentMinJumpVelocity)
		if player.velocity.y > stats.jumpVelocity * stats.percentKeepJumpConsecutive: ## needs to be a percent of full jump to keep it going
			consecutive_jump_cancel()
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
	if player.is_on_ceiling():
		consecutive_jump_cancel()
		return State.Fall
	if player.is_on_wall() and topSpeed > stats.moveSpeed:
		topSpeed = 0
		return State.BonkAir
#		elif player.moveDirection.x == player.wallDirection:
#			return State.WallSlide
	if player.velocity.y > -stats.jumpApexHeight:
		return State.JumpApex
	if player.is_on_floor():
		player.landed()
		if player.velocity.x != 0:
			return State.Walk
		else:
			return State.Idle
	if dashBufferState != State.Null:
		if dashBufferState == State.DashAir and abilities.can_use(PlayerAbilities.list.DashSide):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashAir
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashUp
		if dashBufferState == State.DashDown and abilities.can_use(PlayerAbilities.list.DashDown):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashDown

	return State.Null


func timers () -> void:
	timerCoyoteJump.stop()
	timerConsecutiveJump.stop()
