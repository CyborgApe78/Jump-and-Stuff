extends PlayerInfo


@export var timerBufferJump: Timer

var transformTime: float = 0.1

func enter() -> void:
	## Pulls player off the wall
	player.velocity = Vector2(0, 10)
	player.set_up_direction(Vector2.UP)
	player.animPlayer.queue("Idle")
	if player.characterRig.skew != 0:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(player.characterRig, "skew", 0, transformTime).from_current()


func exit() -> void:
	player.animPlayer.stop()


func physics(delta) -> void:
	player.move_and_slide()


func visual(delta) -> void:
	player.facing_logic()
	align_to_ground()


func handle_input(event: InputEvent) -> int:
	if input.justPressedJump:
		if input.pressedDown:
			player.set_collision_mask_value(CollisionLayers.Semisolid, false)
		else:
			return State.Jump
	if input.justPressedDash:
		dash_pressed_buffer()
	if input.justPressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if input.pressedCrouch: 
		return State.Crouch
	if input.moveDirection.x != 0:
		return State.Walk
	if !player.is_on_floor():
		return State.Fall
	if !timerBufferJump.is_stopped():
		timerBufferJump.stop()
		EventBus.helperUsed.emit(Util.helper.bufferJump)
		return State.Jump
	if dashBufferState != State.Null:
		if dashBufferState == State.DashGround and abilities.can_use(PlayerAbilities.list.DashSide):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashGround
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashUp

	return State.Null
