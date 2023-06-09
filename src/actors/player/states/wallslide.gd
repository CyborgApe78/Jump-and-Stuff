extends PlayerInfo

@export var coyoteJumpWallTimer: Timer
@export var particles: GPUParticles2D

func enter() -> void:
	player.wall_detection()
	player.velocityPrevious = player.velocity
	player.velocity.y = 0
	particles.emitting = true


func exit() -> void:
	player.particles.wallSlide.emitting = false


func physics(delta) -> void:
	player.move_and_slide()
	
	if player.moveDirection.y == Vector2.DOWN.y:
		gravity_logic(gravityFall, delta)
		fall_speed_logic(terminalVelocity)
	else:
		gravity_logic(gravityFall/4, delta)
		fall_speed_logic(terminalVelocity/4)


func visual(delta) -> void:
	pass 
	#TODO: need to move facing func to each state


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("move_left") and player.wall_detection() == Vector2.RIGHT.x:
		player.velocity = Vector2(-20,-10)
		coyoteJumpWallTimer.start()
		return State.Fall
	if Input.is_action_just_pressed("move_right") and player.wall_detection() == Vector2.LEFT.x:
		player.velocity = Vector2(20, -10)
		coyoteJumpWallTimer.start()
		return State.Fall
	if Input.is_action_just_pressed("grab"):
		return State.WallGrab
	if Input.is_action_just_pressed("jump"):
		return State.JumpWall
	#TODO: add dive
	if Input.is_action_just_pressed("ground_pound") and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
	if Input.is_action_just_pressed("dash"): #TODO:dash wall
		if abilities.can_use(PlayerAbilities.list.DashClimb) and player.moveDirection.y == 1:
			return State.DashClimb
		elif abilities.can_use(PlayerAbilities.list.DashSide):
			abilities.consume(PlayerAbilities.list.DashSide, 1)
			return State.DashAir
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook

	return State.Null


func state_check(delta: float) -> int:
	if !player.is_on_wall():
		coyoteJumpWallTimer.start()
		return State.Fall
	if player.is_on_floor():
		player.landed()
		if Input.is_action_pressed("crouch"):
			return State.Crouch
		elif player.velocity.x != 0: 
			return State.Walk
		else:
			return State.Idle

	return State.Null
