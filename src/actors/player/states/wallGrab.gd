extends PlayerInfo


@export var coyoteJumpWallTimer: Timer


func enter() -> void:
	player.velocityPrevious = player.velocity
	player.velocity = Vector2.ZERO
	
	player.facing_logic(-wall.wallDirection)


func exit() -> void:
	pass


func physics(delta) -> void:
	player.move_and_slide()


func visual(delta) -> void:
	pass 


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justReleasedCrouch:
		return State.WallSlide
	if input.justPressedJump and abilities.can_use(PlayerAbilities.list.JumpWall):
		return State.JumpWall
	if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Dive):
		return State.Dive
	if input.justPressedDash:
		if abilities.can_use(PlayerAbilities.list.DashClimb) and input.moveDirection.y == 1:
			return State.DashClimb
		elif abilities.can_use(PlayerAbilities.list.DashWall):
			return State.DashWall
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
