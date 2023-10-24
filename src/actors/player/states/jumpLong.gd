extends PlayerInfo


@export_group("Connections")
@export var timerBufferJump: Timer
@export var timerBufferRoll: Timer
@export var soundeffect: AudioStreamPlayer
@export var particles: GPUParticles2D

@export_group("")
@export var jumpSoundModifier: float = 0.9

var startingHeight: int


func enter() -> void:
	EventBus.playerJumped.emit()
	
	startingHeight = player.global_position.y
	velocity.topSpeed = 0
	
	player.velocity.y = stats.jumpLongVelocity
	player.velocity.x = max(stats.jumpLongSpeed, abs(player.velocity.x)) * player.facing
	
	player.animPlayer.queue("Jump")
	
	soundeffect.pitch_scale = jumpSoundModifier
	soundeffect.play()
	particles.restart()
	
	neutral_move_direction_logic()
	timers()


func exit() -> void:
	player.animPlayer.stop()
	soundeffect.pitch_scale = 1


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(stats.jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(stats.jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	
	velocity.gravity_logic(stats.gravityJump, delta)
	
	if player.neutralMoveDirection:
		neutral_move_direction_logic()
		if abs(player.velocity.x) < stats.jumpLongSpeed:
			player.velocity.x = move_toward(abs(player.velocity.x), stats.jumpLongSpeed, (stats.moveSpeed * 3) * delta) * player.facing
			#TODO: long jump acceleration
	else:
		if input.moveDirection.x != 0:
			if input.moveDirection.x != player.facing:
#				player.velocity.x = move_toward(player.velocity.x, 0, (moveSpeed * 2) * delta)
				velocity.apply_friction(stats.moveSpeed * 3, delta) #TODO: add to stats
			elif input.moveDirection.x == player.facing and abs(player.velocity.x) < stats.jumpLongSpeed:
#					velocity.apply_acceleration(velocityLongJump, moveSpeed * 3, delta) #TODO: make func to input direction
					player.velocity.x = move_toward(abs(player.velocity.x), stats.jumpLongVelocity, (stats.moveSpeed * 3) * delta) * player.facing
	
	velocity.track_top_speed(player.velocity.x)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justPressedJump:
		if abilities.can_use(PlayerAbilities.list.JumpAir) and !(ground.detectorGroundLeft.is_colliding() or ground.detectorGroundRight.is_colliding()):
			return State.JumpAir
		else:
			timerBufferJump.start()
	if input.justPressedGlide and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
#	if input.justPressedCrouch and abilities.can_use(PlayerAbilities.list.GroundPound): 
#		return State.GroundPound
	if input.justPressedDash:
		dash_pressed_buffer()
	if input.justPressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim
#	if !input.pressedCrouch:
		#TODO: change velocity based on whether crouch is held
	if input.justPressedDive:
		if input.pressedCrouch:
			timerBufferRoll.start()
		else:
			return State.Dive

	return State.Null


func state_check(delta: float) -> int:
	if player.global_position.y > startingHeight: ## leave state when passing starting height
		return State.Fall
	if player.is_on_wall():
		if !timerBufferJump.is_stopped():
			return State.JumpWall
		elif velocity.topSpeed > stats.moveSpeed:
			velocity.topSpeed = 0
			return State.BonkAir
		else:
			return State.WallSlide
	if player.is_on_floor():
		player.landed()
		EventBus.rumble.emit(0.1, 0.2, 0.2)
		if input.pressedCrouch:
			if !timerBufferJump.is_stopped():
				timerBufferJump.stop()
				player.velocity.x = max(stats.jumpLongChainSpeed, abs(player.velocity.x)) * player.facing
				return State.JumpLong
			elif !timerBufferRoll.is_stopped():
				timerBufferRoll.stop()
				return State.Roll
			else:
				return State.Crouch
		elif !timerBufferJump.is_stopped():
			timerBufferJump.stop()
			return State.Jump
		elif player.velocity.x != 0:
			if input.moveDirection.x != sign(player.velocity.x) and input.moveDirection.x != 0:
				return State.Skid
			else:
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

func timers() -> void:
	pass
