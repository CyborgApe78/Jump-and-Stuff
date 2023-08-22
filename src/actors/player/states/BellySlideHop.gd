extends PlayerInfo


@export var timerDuration: Timer
@export var detector: ShapeCast2D
@export var timerBufferJump: Timer
@export var timerBufferRoll: Timer
@export var soundeffect: AudioStreamPlayer
@export var particles: GPUParticles2D #TODO: own particles

@export var duration: float = 0.2
@export var jumpModifier: float = 0.25
@export var velocityModifier: float = 1.0


var startingHeight: int
var velocityHop: float


func enter() -> void:
	velocityHop = moveSpeed * velocityModifier
	startingHeight = player.global_position.y
	topSpeed = 0
	
	player.velocity.x = velocityHop * player.facing
	player.velocity.y = jumpVelocity * jumpModifier
#	if !detector.is_colliding():
#		player.global_position.y -= Util.tileSize * 4 #TODO: tween movement or change to velocity
	
	EventBus.playerJumped.emit()
	
	player.animPlayer.queue("Belly Slide")
	
	soundeffect.pitch_scale = jumpModifier
	soundeffect.play()
	particles.restart()
	
	timers()
	neutral_move_direction_logic()


func exit() -> void:
	player.animPlayer.stop()
	soundeffect.pitch_scale = 1
	timerDuration.stop()


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	player.attempt_vertical_corner_correction(-jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	
	if timerDuration.is_stopped():
		gravity_logic(gravityJump, delta)
	
	if player.neutralMoveDirection:
		neutral_move_direction_logic()
		if abs(player.velocity.x) < velocityHop:
			player.velocity.x = move_toward(abs(player.velocity.x), velocityHop, (moveSpeed * 3) * delta) * player.facing
	else:
		if player.moveDirection.x != 0:
			if player.moveDirection.x != player.facing:
#				player.velocity.x = move_toward(player.velocity.x, 0, (moveSpeed * 2) * delta)
				apply_friction(moveSpeed * 2, delta)
			elif player.moveDirection.x == player.facing and abs(player.velocity.x) < velocityHop:
#					apply_acceleration(velocityLongJump, moveSpeed * 3, delta) #TODO: make func to input direction
					player.velocity.x = move_toward(abs(player.velocity.x), velocityHop, (moveSpeed * 3) * delta) * player.facing
	
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		if abilities.can_use(PlayerAbilities.list.JumpAir) and !(player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding()):
			return State.JumpAir
	if Input.is_action_just_pressed("roll"):
		timerBufferRoll.start()
	if Input.is_action_just_pressed("glide") and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
#	if Input.is_action_just_pressed("dive") and abilities.can_use(PlayerAbilities.list.Dive):
#		return State.Dive ## removed since interfers with roll
	if Input.is_action_just_pressed("ground_pound"):
		if abilities.can_use(PlayerAbilities.list.GroundPound): 
			return State.GroundPound
		else:
			return State.Fall
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if Input.is_action_just_pressed("bash") and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if player.global_position.y > startingHeight: ## leave state when passing starting height
		return State.Fall
	if player.is_on_ceiling():
		return State.Fall
	if player.wallDirection != 0:
		if topSpeed > moveSpeed:
			topSpeed = 0
			return State.BonkAir
#		else:
#			return State.WallSlide
	if player.is_on_floor():
		if !timerBufferRoll.is_stopped():
			timerBufferRoll.stop()
			return State.Roll
		else:
			return State.BellySlide
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
	timerDuration.wait_time = duration
	timerDuration.start()
