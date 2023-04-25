extends PlayerInfo

@export var transformTime: float = 0.4
#TODO: make a no control state, for teleport and such


func enter() -> void:
	if CheckpointSystem.get_respawn() != Vector2.ZERO:
		player.global_position = CheckpointSystem.get_respawn()
	player.animPlayer.play("Spawn")
	EventBus.playerStatsCheck.emit()


func exit() -> void:
	player.animPlayer.stop()
	player.characterRig.scale = Vector2(1,1) ## Makes sure character is full size ##


func physics(delta) -> void:
	if !player.is_on_floor():
		player.move_and_slide()
		player.velocity.y = 2000
	elif  player.is_on_floor():
		player.velocity = Vector2.ZERO



func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if player.is_on_floor():
		if Input.is_action_pressed("crouch"): 
			return State.Crouch
		if Input.is_action_just_pressed("jump"):
			return State.Jump
		if Input.is_action_just_pressed("dash"):
			dash_pressed_buffer()
		if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
			return State.GrappleHook

	return State.Null


func state_check(delta: float) -> int:
	if player.moveDirection != Vector2.ZERO:
		return State.Walk
	if dashBufferState != State.Null:
		if abilities.can_use(PlayerAbilities.list.DashSide) and dashBufferState == State.DashGround:
			abilities.consume(PlayerAbilities.list.DashSide, 1)
			return State.DashAir
		if abilities.can_use(PlayerAbilities.list.DashUp) and dashBufferState == State.DashUp:
			abilities.consume(PlayerAbilities.list.DashUp, 1)
			return State.DashUp
		if abilities.can_use(PlayerAbilities.list.DashDown) and dashBufferState == State.DashDown:
			abilities.consume(PlayerAbilities.list.DashDown, 1)
			return State.DashDown

	return State.Null
