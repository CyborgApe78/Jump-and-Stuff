extends PlayerInfo


## jump that keeps crouch shoe. 
#TODO: look at adding match state


@export_group("Connections")
@export var soundeffect: AudioStreamPlayer
@export var particles: GPUParticles2D
@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer


@export_group("")
@export var jumpSoundModifier: float = 1.2


func enter() -> void:
	EventBus.playerJumped.emit()
	velocity.topSpeed = 0
	neutral_move_direction_logic()
	player.animPlayer.queue("Crouch")
	soundeffect.pitch_scale = jumpSoundModifier
	soundeffect.play()
	particles.restart()
	player.velocity.y = stats.jumpRunVelocity #TODO: own velocity
	player.velocity.x = 0


func exit() -> void:
	player.animPlayer.stop()
	soundeffect.pitch_scale = 1


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(stats.jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(stats.jumpCornerCorrectionVertical, delta)
	
	## self contained fall state
	if player.velocity.y < -stats.jumpApexHeight and input.pressedJump:
		velocity.gravity_logic(stats.gravityJump, delta)
	elif player.velocity.y < stats.jumpApexHeight and input.pressedJump:
		velocity.gravity_logic(stats.gravityApex, delta)
	else:
		velocity.gravity_logic(stats.gravityFall, delta)
	
	velocity.air_velocity_logic(stats.moveSpeed / 4, stats.accelerationAir, stats.frictionAir, delta)
												#TODO: own move speed
	player.move_and_slide_rotation()
	velocity.track_top_speed(player.velocity.x)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
#	if input.pressedDown: #LOOKAT: are these needed
#		player.set_collision_mask_value(CollisionLayers.Semisolid, false)
#		timerSemisolidReset.stop()
#	if input.justPressedDown:
#		timerSemisolidReset.start()
	if input.justReleasedJump and player.velocity.y < -stats.jumpApexHeight:
		player.velocity.y = max(player.velocity.y, stats.jumpCrouchVelocity * stats.percentMinJumpVelocity)
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
	if player.velocity.y > 0: #TODO: create is_falling(): checks if positive y velocity v
		if input.justPressedJump:
			if abilities.can_use(PlayerAbilities.list.JumpAir) and !(ground.detectorGroundLeft.is_colliding() or ground.detectorGroundRight.is_colliding()):
				#FIXME: create function to call from ground check that can be used by other states
				return State.JumpAir
			else:
				timerBufferJump.start()

	return State.Null


func state_check(delta: float) -> int:
#	if player.is_on_wall() and input.moveDirection.x == wall.wallDirection:
#		return State.WallSlide
#	if player.velocity.y > -stats.jumpApexHeight:
#		return State.JumpApex
	if player.is_on_floor():
		player.landed()
		if player.velocity.x != 0:
			return State.CrouchWalk
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
