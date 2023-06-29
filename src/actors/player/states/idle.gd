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
	pass


func physics(delta) -> void:
	player.move_and_slide()


func visual(delta) -> void:
	player.facing_logic()
	align_to_ground()


func handle_input(event: InputEvent) -> int:
	if Input.is_action_pressed("crouch"): 
		return State.Crouch
	if Input.is_action_just_pressed("jump"):
		if Input.is_action_pressed("move_down"):
			player.set_collision_mask_value(CollisionLayers.Semisolid, false)
		else:
			return State.Jump
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashSide):
		abilities.consume(PlayerAbilities.list.DashSide, 1)
		return State.DashGround
	if Input.is_action_just_pressed("slide"):
		return State.Slide
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if Input.is_action_just_pressed("bash") and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if player.moveDirection.x != 0:
		return State.Walk
	if !player.is_on_floor():
		return State.Fall
	if !timerBufferJump.is_stopped():
		timerBufferJump.stop()
		EventBus.helperUsed.emit(Util.helper.bufferJump)
		return State.Jump

	return State.Null
