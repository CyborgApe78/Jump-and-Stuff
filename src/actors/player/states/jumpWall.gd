extends PlayerInfo

#FIXME: coyote wall jump flips sprite away from wall, but returns to face wall without input. adjust facing to match on exit
#TODO: make other wall jumps not go back to wall and gain height

@export var timerCoyoteJumpWall: Timer
@export var timerLock: Timer
@export var particles: GPUParticles2D
@export var soundeffect: AudioStreamPlayer

var wallHop: bool
var jumpDirection: int


func enter() -> void:
	EventBus.playerJumped.emit()
	timerLock.start()
	jumpDirection = wall.wall_detection(30)
	
	neutral_move_direction_logic()
	player.animPlayer.queue("Jump")
	soundeffect.play()
	
	if !timerCoyoteJumpWall.is_stopped():
		jumpDirection = wall.lastWallDirection
		timerCoyoteJumpWall.stop()
		
	## up pressed
	if input.moveDirection.y == -1:
		player.characterRig.scale.x = wall.wallDirection #TODO: use facing func
		player.velocity = Vector2(100 * -jumpDirection, stats.jumpVelocity * 1.0)
	## down pressed
	elif input.moveDirection.y == 1:
		player.characterRig.scale.x = wall.wallDirection
		player.velocity = Vector2(300 * -jumpDirection, 100)
	## no directional input
	elif input.moveDirection.x == 0:
		player.characterRig.scale.x = -wall.wallDirection
		player.velocity = Vector2(max(stats.moveSpeed / 1.5 , abs(player.velocityPrevious.x)) * -jumpDirection, stats.jumpVelocity * 0.9)
	## towards from wall pressed
	elif input.moveDirection.x == jumpDirection and abilities.can_use(PlayerAbilities.list.JumpWallSame): 
		player.characterRig.scale.x = wall.wallDirection
		player.velocity = Vector2(200 * -jumpDirection, stats.jumpVelocity * 0.8)
		wallHop = true
	## away from wall pressed
	else:
		player.characterRig.scale.x = -wall.wallDirection
		player.velocity = Vector2(stats.moveSpeed * -jumpDirection, stats.jumpVelocity * 0.7)
	
	particles.restart()
	velocity.topSpeed = 0


func exit() -> void:
	player.animPlayer.stop()


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(stats.jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(stats.jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide_rotation()
	#FIXME: create full velocity logic, currently can back to wall sometimes, look at long jump state change
	if timerLock.is_stopped():
		if player.neutralMoveDirection:
			neutral_air_momentum_logic(stats.moveSpeed)
		else:
			if input.moveDirection.x != 0:
				velocity.apply_acceleration(stats.moveSpeed, stats.accelerationAir, delta)
			elif input.moveDirection.x == 0:
				velocity.apply_friction(stats.frictionAir, delta)
	velocity.gravity_logic(stats.gravityJump, delta)
	
	#TODO: air velocity func
#	velocity.air_velocity_logic(moveSpeed, accelerationAir, frictionAir, delta)
	
	velocity.track_top_speed(player.velocity.x)


func visual(delta) -> void:
	squash_and_stretch(delta)


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
