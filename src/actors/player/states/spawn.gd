extends PlayerInfo

@export var transformTime: float = 0.4
#TODO: make a no control state, for teleport and such


func enter() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(player.characterRig, "scale", Vector2(1,1), transformTime).from(Vector2(0,0))
	EventBus.emit_signal("playerStatsCheck")
	


func exit() -> void:
	player.characterRig.scale = Vector2(1,1) ## Makes sure character is full size ##
	player.landed()


func physics(delta) -> void:
	if !player.is_on_floor():
		player.move_and_slide()
		player.velocity.y = 2000
	else:
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

	return State.Null


func state_check(delta: float) -> int:
	if player.moveDirection != Vector2.ZERO:
		return State.Walk
	if dashBufferState != State.Null:
		if abilities.can_use(PlayerAbilities.list.DashSide) and dashBufferState == State.DashGround:
			dashBufferState = State.Null
			return State.DashGround
		if abilities.can_use(PlayerAbilities.list.DashUp) and dashBufferState == State.DashUp:
			dashBufferState = State.Null
			return State.DashUp
		if abilities.can_use(PlayerAbilities.list.DashDown) and dashBufferState == State.DashDown:
			dashBufferState = State.Null
			return State.DashDown

	return State.Null
