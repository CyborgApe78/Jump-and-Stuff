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


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justPressedLeft and player.wall_detection() == Vector2.RIGHT.x:
		player.velocity = Vector2(-20,-10)
		coyoteJumpWallTimer.start()
		return State.Fall
	if input.justPressedRight and player.wall_detection() == Vector2.LEFT.x:
		player.velocity = Vector2(20, -10)
		coyoteJumpWallTimer.start()
		return State.Fall
	if input.justReleasedGrab:
		return State.WallSlide
	if input.justPressedJump and abilities.can_use(PlayerAbilities.list.JumpWall):
		return State.JumpWall
	if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Dive):
		return State.Dive
	if input.justPressedCrouch and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
	if input.justPressedDash:
		if abilities.can_use(PlayerAbilities.list.DashClimb) and player.moveDirection.y == 1:
			return State.DashClimb
		elif abilities.can_use(PlayerAbilities.list.DashWall): #TODO: add charge
			return State.DashWall #LOOKAT: should this be like other dash checks
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
		EventBus.rumble.emit(0.1, 0.2, 0.2)
		if input.pressedCrouch:
			return State.Crouch
		elif player.velocity.x != 0: 
			return State.Walk
		else:
			return State.Idle

	return State.Null
