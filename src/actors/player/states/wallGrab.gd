extends PlayerInfo

@export var coyoteJumpWallTimer: Timer
#TODO: redirect previous velocity bassed on aim direction

func enter() -> void:
	player.wall_detection()
	player.velocityPrevious = player.velocity
	player.velocity = Vector2.ZERO


func exit() -> void:
	pass


func physics(delta) -> void:
	player.move_and_slide()


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
	if Input.is_action_just_released("grab"):
		return State.WallSlide
	if Input.is_action_just_pressed("jump"):
		return State.JumpWall
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()
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
	if dashBufferState != State.Null:
		if abilities.can_use(PlayerAbilities.list.DashWall) and dashBufferState == State.DashAir:
			return State.DashWall
		if abilities.can_use(PlayerAbilities.list.DashClimb) and dashBufferState == State.DashClimb:
			return State.DashClimb
		#Lookat: need other dash states

	return State.Null
