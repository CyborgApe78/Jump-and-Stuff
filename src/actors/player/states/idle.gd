extends PlayerInfo

var transformTime: float = 0.1

func enter() -> void:
	## Pulls player off the wall
	#TODO: check rotation to move off wall
	player.velocity = Vector2(0, 10)
	player.set_up_direction(Vector2.UP)
	player.animPlayer.queue("Idle")
	if player.characterRig.skew != 0:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT) #LOOKAT: move to player info
		tween.tween_property(player.characterRig, "skew", 0, transformTime).from_current()


func exit() -> void:
	pass


func physics(delta) -> void:
	player.move_and_slide()


func visual(delta) -> void:
	player.facing_logic()
	align_to_ground()


func handle_input(event: InputEvent) -> int:
	if Input.is_action_pressed("crouch"): 
		return State.Crouch
	if Input.is_action_just_pressed("jump"): #LOOKAT: can't consec jump from idle, watch if that causes problems
		return State.Jump
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()
	if Input.is_action_just_pressed("slide"):
		return State.Slide

	return State.Null


func state_check(delta: float) -> int:
	if player.moveDirection.x != 0:
		return State.Walk
	if !player.is_on_floor():
		return State.Fall
	if !player.timers.bufferJump.is_stopped():
		player.timers.bufferJump.stop()
		EventBus.helperUsed.emit(Util.helper.bufferJump)
		return State.Jump
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
