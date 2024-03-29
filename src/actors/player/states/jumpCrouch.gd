extends PlayerInfo


## jump that keeps crouch shoe


@export_group("Connections")
@export var soundeffect: AudioStreamPlayer
@export var particles: GPUParticles2D
@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var detector: ShapeCast2D


@export_group("")
@export var jumpSoundModifier: float = 1.2

#TODO: add match state
enum state {jump, apex, fall}
var currentState: int


func enter() -> void:
	EventBus.playerJumped.emit()
	velocity.topSpeed = 0
	input.neutral_move_direction_logic()
	player.animPlayer.queue("Crouch")
	soundeffect.pitch_scale = jumpSoundModifier
	soundeffect.play()
	particles.restart()
	player.velocity.y = stats.jumpCrouchVelocity
	player.velocity.x = 0


func exit() -> void:
	player.animPlayer.stop()
	soundeffect.pitch_scale = 1


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(stats.jumpCornerCorrectionHorizontal, delta)
#	player.attempt_vertical_corner_correction(stats.jumpCornerCorrectionVertical, delta)
	
	## self contained fall state
	if player.velocity.y < -stats.jumpApexHeight and input.pressedJump:
		velocity.gravity_logic(stats.gravityJump, delta)
	elif player.velocity.y < stats.jumpApexHeight and input.pressedJump:
		velocity.gravity_logic(stats.gravityApex, delta)
	else:
		velocity.gravity_logic(stats.gravityFall, delta)
	
	velocity.air_velocity_logic(stats.moveSpeed * stats.crouchSpeedModifier, stats.accelerationAir, stats.frictionAir, delta)
	player.move_and_slide_rotation()
	velocity.track_top_speed(player.velocity.x)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justReleasedJump and player.velocity.y < -stats.jumpApexHeight:
		player.velocity.y = max(player.velocity.y, stats.jumpCrouchVelocity * stats.percentMinJumpVelocity)
	if !detector.is_colliding():
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
		if player.velocity.y > 0:
			if input.justPressedJump:
				if abilities.can_use(PlayerAbilities.list.JumpAir) and !(ground.detectorGroundLeft.is_colliding() or ground.detectorGroundRight.is_colliding()):
					return State.JumpAir
				else:
					timerBufferJump.start()

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_floor():
		player.landed()
		if player.velocity.x != 0:
			return State.CrouchWalk
		elif detector.is_colliding():
			return State.Crouch
		elif input.pressedCrouch:
			return State.Crouch
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
