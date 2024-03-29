extends PlayerInfo


@export_group("Connections")
@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var timerBufferRoll: Timer
@export var fallTimer: Timer

@export_group("")
@export var rollTime: float = 0.3
@export var diveSpeedMultiplier: float = 1.6
@export var multiplierGroundPound: float = 1.5
@export var transformTime: float = 0.05
@export var fallTimeTillBonk: float = .7


func enter() -> void:
	player.velocity.x = max(stats.moveSpeed, abs(player.velocity.x)) * player.facing
	
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(player.characterRotate, "rotation_degrees", 125, transformTime).from(0)
	tween.tween_property(player.characterCollision, "rotation_degrees", 125 * player.facing, transformTime).from(0)
	
	timers()


func exit() -> void:
	pass


func physics(delta: float) -> void:
	player.attempt_vertical_corner_correction(stats.jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	
	if input.moveDirection.x != 0 and input.moveDirection.x != player.facing:
			velocity.apply_friction(stats.moveSpeed * 2, delta)
	
	velocity.gravity_logic(stats.gravityFall, delta)
	velocity.fall_speed_logic(stats.terminalVelocity)
	velocity.track_top_speed(player.velocity.x)


func visual(delta) -> void:
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justPressedJump:
		if !timerCoyoteJump.is_stopped(): #leave ground, but stil can jump
			timerCoyoteJump.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			return consecutive_jump_logic()
		elif abilities.can_use(PlayerAbilities.list.JumpAir) and !(ground.detectorGroundLeft.is_colliding() or ground.detectorGroundRight.is_colliding()):
			return State.JumpAir
		else:
			timerBufferJump.start()
			return State.Fall
	if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Roll):
		timerBufferRoll.start()
	if input.justPressedGlide and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if input.justPressedDash:
		dash_pressed_buffer()
	if input.justPressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall() and velocity.topSpeed > stats.moveSpeed:
		velocity.topSpeed = 0
		return State.BonkAir
	if player.is_on_floor():
		EventBus.playerLanded.emit()
		if !timerBufferRoll.is_stopped():
			EventBus.rumble.emit(0.1, 0.2, 0.2)
			return State.Roll
		elif fallTimer.is_stopped():
			return State.BonkGround
		else:
			EventBus.rumble.emit(0.2, 0.3, 0.2)
			return State.BellySlide
	if dashBufferState != State.Null:
		if dashBufferState == State.DashAir and abilities.can_use(PlayerAbilities.list.DashSide):
			return State.DashAir
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			return State.DashUp
		if dashBufferState == State.DashDown and abilities.can_use(PlayerAbilities.list.DashDown):
			return State.DashDown

	return State.Null

func timers() -> void:
	fallTimer.wait_time = fallTimeTillBonk
	fallTimer.start()
