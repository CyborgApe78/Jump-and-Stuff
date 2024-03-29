extends PlayerInfo


@export_group("Connections")
@export var timerDuration: Timer
@export var timerBufferJump: Timer
@export var timerBufferRoll: Timer
@export var soundeffect: AudioStreamPlayer
@export var particles: GPUParticles2D
@export var detector: ShapeCast2D

@export_group("")
@export var duration: float = 0.3
@export var jumpModifier: float = 0.25

var startingHeight: int


func enter() -> void:
	startingHeight = player.global_position.y
	EventBus.playerJumped.emit()
	velocity.topSpeed = 0
	input.neutral_move_direction_logic()
	player.animPlayer.queue("Roll")
	soundeffect.pitch_scale = jumpModifier
	soundeffect.play()
	if player.is_on_floor():
		particles.restart()
	if !detector.is_colliding():
		player.global_position.y -= Util.tileSize * 2 #TODO: tween movement or change to velocity
	player.velocity.x = player.facing * max(stats.moveSpeed * stats.rollJumpVelocityModifier, abs(player.velocity.x)) #LOOKAT: should there be accel
	timers()


func exit() -> void:
	timerDuration.stop()
	player.animPlayer.stop()
	soundeffect.pitch_scale = 1


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(stats.jumpCornerCorrectionHorizontal, delta)
#	player.attempt_vertical_corner_correction(stats.jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide_rotation()
	
	if timerDuration.is_stopped():
		velocity.gravity_logic(stats.gravityJump, delta)
	else:
		player.velocity.y = 0


func visual(delta) -> void:
	player.facing_logic(input.moveDirection.x)


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justPressedJump:
		if abilities.can_use(PlayerAbilities.list.JumpAir) and !(ground.detectorGroundLeft.is_colliding() or ground.detectorGroundRight.is_colliding()):
			player.velocity.x = 0
			return State.JumpAir
		else:
			timerBufferJump.start()
			player.velocity.x = 0
			return State.Fall
	if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Roll):
		timerBufferRoll.start()
	if input.justPressedGlide and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
#	if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Dive):
#		return State.Dive ## removed since interfers with roll
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
	if player.global_position.y > startingHeight: ## leave state when passing starting height
		return State.Fall
	if player.is_on_ceiling():
		return State.Fall
	if wall.wallDirection != 0:
		if velocity.topSpeed > stats.moveSpeed: #TODO: make func to check if bonk enabled
			velocity.topSpeed = 0
			return State.BonkAir
		else:
			return State.WallSlide
	if player.is_on_floor() and timerDuration.is_stopped():
		EventBus.playerLanded.emit() #TODO: added landed when changed to squishing player instead of anim
#		player.landed()
		if !timerBufferRoll.is_stopped() and abilities.can_use(PlayerAbilities.list.Roll):
			timerBufferRoll.stop()
			return State.Roll
		elif !detector.is_colliding():
			player.landed()
			if player.velocity.x != 0:
				return State.Walk
			else:
				return State.Idle
		else:
			player.velocity.x = 0
			return State.Crouch
	if dashBufferState != State.Null:
		if dashBufferState == State.DashAir and abilities.can_use(PlayerAbilities.list.DashSide):
			return State.DashAir
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			return State.DashUp
		if dashBufferState == State.DashDown and abilities.can_use(PlayerAbilities.list.DashDown):
			return State.DashDown

	return State.Null


func timers () -> void:
	timerDuration.wait_time = duration
	timerDuration.start()
