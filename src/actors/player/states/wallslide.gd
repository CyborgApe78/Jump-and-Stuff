extends PlayerInfo


@export_group("Connections")
@export var coyoteJumpWallTimer: Timer
@export var particles: GPUParticles2D

@export_group("")


func enter() -> void:
	player.animPlayer.play("Wall Slide")
	
	player.velocityPrevious = player.velocity
	particles.emitting = true
	abilities.reset(PlayerAbilities.list.All)
	
	player.facing_logic(-wall.wallDirection)


func exit() -> void:
	player.animPlayer.stop()
	player.particles.wallSlide.emitting = false


func physics(delta) -> void:
	player.move_and_slide()
	
	if input.moveDirection.y == Vector2.DOWN.y:
		velocity.gravity_logic(stats.gravityFall, delta)
		velocity.fall_speed_logic(stats.terminalVelocity)
	else:
		velocity.gravity_logic(stats.gravityFall/10, delta)
		velocity.fall_speed_logic(stats.terminalVelocity/4)
	player.velocity.x = 10 * wall.wallDirection


func visual(delta) -> void:
	pass 


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justPressedLeft and wall.wall_detection() == Vector2.RIGHT.x:
		player.velocity = Vector2(-20,-10)
		coyoteJumpWallTimer.start()
		return State.Fall
	if input.justPressedRight and wall.wall_detection() == Vector2.LEFT.x:
		player.velocity = Vector2(20, -10)
		coyoteJumpWallTimer.start()
		return State.Fall
#	if input.justPressedCrouch and abilities.can_use(PlayerAbilities.list.WallGrab):
#		return State.WallGrab
	if input.justPressedJump and abilities.can_use(PlayerAbilities.list.JumpWall):
		return State.JumpWall
#	if input.justPressedCrouch and abilities.can_use(PlayerAbilities.list.GroundPound): 
#		return State.GroundPound
	if input.justPressedCrouch: 
		return State.WallGrab
	if input.justPressedDash:
		dash_pressed_buffer()
	if input.justPressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if !player.is_on_wall():
		coyoteJumpWallTimer.start()
		return State.Fall
	if player.is_on_floor():
		player.landed()
		if input.pressedCrouch:
			return State.Crouch
		elif player.velocity.x != 0: 
			return State.Walk
		else:
			return State.Idle
	if dashBufferState != State.Null:
		if dashBufferState == State.DashClimb and abilities.can_use(PlayerAbilities.list.DashClimb):
			return State.DashClimb
		if dashBufferState == State.DashAir and abilities.can_use(PlayerAbilities.list.DashSide):
			return State.DashAir
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			return State.DashUp
		if dashBufferState == State.DashDown and abilities.can_use(PlayerAbilities.list.DashDown):
			return State.DashDown

	return State.Null
