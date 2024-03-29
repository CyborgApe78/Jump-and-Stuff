extends PlayerInfo


@export_group("Connections")
@export var soundeffect: AudioStreamPlayer
@export var timerCoyoteJumpGroundPound: Timer
@export var particles: GPUParticles2D

@export_group("")
@export var jumpSoundModifier: float = 3.0

var velocityJumpCrouch: float


func enter() -> void:
	timerCoyoteJumpGroundPound.stop()
	velocityJumpCrouch = stats.jumpGroundPoundVelocity
	EventBus.playerJumped.emit()
	velocity.topSpeed = 0
	input.neutral_move_direction_logic()
	player.animPlayer.queue("Jump")
	soundeffect.pitch_scale = jumpSoundModifier
	soundeffect.play()
	particles.restart()
	player.velocity.y = velocityJumpCrouch


func exit() -> void:
	player.animPlayer.stop()
	soundeffect.pitch_scale = 1


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(stats.jumpCornerCorrectionHorizontal, delta)
#	player.attempt_vertical_corner_correction(stats.jumpCornerCorrectionVertical, delta)
	
	velocity.gravity_logic(stats.gravityJump, delta)
	
	
	if input.neutralMoveDirection:
		neutral_air_momentum_logic(stats.moveSpeed)
	else:
		velocity.air_velocity_logic(stats.moveSpeed, stats.accelerationAir, stats.frictionAir, delta)
		
	player.move_and_slide_rotation()
	velocity.track_top_speed(player.velocity.x)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justReleasedJump:
		player.velocity.y = max(player.velocity.y, stats.velocityJumpCrouch * stats.percentMinJumpVelocity)
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
#	if player.is_on_wall() and input.moveDirection.x == wall.wallDirection:
#		return State.WallSlide
	if player.velocity.y > -stats.jumpApexHeight:
		return State.JumpApex
	if player.is_on_floor():
		player.landed()
		if player.velocity.x != 0:
			return State.Walk
		else:
			return State.Idle
	if player.is_on_ceiling():
		return State.Fall
	if dashBufferState != State.Null:
		if dashBufferState == State.DashAir and abilities.can_use(PlayerAbilities.list.DashSide):
			return State.DashAir
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			return State.DashUp
		if dashBufferState == State.DashDown and abilities.can_use(PlayerAbilities.list.DashDown):
			return State.DashDown

	return State.Null
