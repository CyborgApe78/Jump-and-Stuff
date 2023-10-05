extends PlayerInfo

#FIXME: breaks if no movement before leaving state

@export var transformTime: float = 0.4
#TODO: make a no control state, for teleport and such


func enter() -> void:
	if CheckpointSystem.get_respawn() != Vector2.ZERO:
		player.global_position = CheckpointSystem.get_respawn()
#	player.animPlayer.play("Spawn") #breaks some states
	EventBus.playerStatsCheck.emit()
#	var faceState = randi_range(0, 1) 
#	if faceState == 1:
#		player.scale.x = 1
#	else:
#		player.scale.x = -1


func exit() -> void:
	player.animPlayer.stop()


func physics(delta) -> void:
	if !player.is_on_floor():
		player.move_and_slide()
		player.velocity.y = 2000
	elif player.is_on_floor():
		player.velocity = Vector2.ZERO



func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if player.is_on_floor():
		if input.justPressedCrouch: 
			return State.Crouch
		if input.justPressedJump:
			return State.Jump
		if input.justPressedDash:
			dash_pressed_buffer()
		if input.justPressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
			return State.GrappleHook
		if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
			return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if input.moveDirection != Vector2.ZERO:
		return State.Walk
	if dashBufferState != State.Null:
		if dashBufferState == State.DashGround and abilities.can_use(PlayerAbilities.list.DashSide):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashGround
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashUp

	return State.Null
