extends PlayerInfo


@export_group("Connections")
@export var soundeffect: AudioStreamPlayer
@export var jumpSoundModifier: float = 1.75
@export var transTime: float = 0.5
@export var particles: GPUParticles2D

@export_group("")


func enter() -> void:
	EventBus.playerJumped.emit()
	velocity.topSpeed = 0
	input.neutral_move_direction_logic()
	player.animPlayer.queue("Jump")
	soundeffect.pitch_scale = jumpSoundModifier
	soundeffect.play()
	particles.restart()
	player.velocity.x = -player.velocity.x
	player.velocity.y = stats.jumpFlipVelocity
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(player.characterRotate,"rotation", player.facing * 4 * PI, transTime) ## flip,
	tween.tween_property(player.characterCollision,"rotation", player.facing * 4 * PI, transTime)


func exit() -> void:
	player.animPlayer.stop()
	soundeffect.pitch_scale = 1
	player.characterRotate.rotation_degrees = 0
	player.characterCollision.rotation_degrees = 0 


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
		player.velocity.y = max( player.velocity.y, stats.jumpFlipVelocity * stats.percentMinJumpVelocity)
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
	if player.is_on_wall() and velocity.topSpeed > stats.moveSpeed:
		velocity.topSpeed = 0
		return State.BonkAir
#		elif input.moveDirection.x == wall.wallDirection:
#			return State.WallSlide
	if player.velocity.y > -stats.jumpApexHeight:
		return State.JumpApex
	if player.is_on_floor():
		player.landed()
		EventBus.rumble.emit(0.1, 0.2, 0.2)
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
