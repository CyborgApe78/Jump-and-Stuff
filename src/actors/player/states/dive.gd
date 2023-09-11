extends PlayerInfo

#todo: homing dive into bouncy things
#FIXME: collision shape is wrong when going left
#FIXME: breaks on semisolids

@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var timerBufferRoll: Timer
@export var fallTimer: Timer


@export var rollTime: float = 0.3
@export var diveSpeedMultiplier: float = 1.6
@export var multiplierGroundPound: float = 1.5
@export var transformTime: float = 0.05
@export var fallTimeTillBonk: float = .7


func enter() -> void:
	player.velocity.x = max(stats.moveSpeed, abs(player.velocity.x)) * player.facing
	
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(player.characterRotate, "rotation_degrees", 125, transformTime).from(0)
	tween.tween_property(player.characterCollision, "rotation_degrees", 125, transformTime).from(0)
	
	timers()


func exit() -> void:
	pass


func physics(delta: float) -> void:
	player.attempt_vertical_corner_correction(stats.jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	
	if player.moveDirection.x != 0 and player.moveDirection.x != player.facing: #TODO: add speed in moving that direction
			apply_friction(stats.moveSpeed * 2, delta)
	
	gravity_logic(stats.gravityFall, delta)
	fall_speed_logic(stats.terminalVelocity)
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	squash_and_stretch(delta)
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		if !timerCoyoteJump.is_stopped(): #leave ground, but stil can jump
			timerCoyoteJump.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			return consecutive_jump_logic()
		elif abilities.can_use(PlayerAbilities.list.JumpAir) and !(player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding()):
			return State.JumpAir
		else:
			timerBufferJump.start()
			return State.Fall
	if Input.is_action_just_pressed("roll") and abilities.can_use(PlayerAbilities.list.Roll):
		timerBufferRoll.start()
	if Input.is_action_just_pressed("glide") and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
#	if Input.is_action_just_pressed("ground_pound") and abilities.can_use(PlayerAbilities.list.GroundPound): 
#		return State.GroundPound ## Removed to make it easier to get to roll state
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if Input.is_action_just_pressed("bash") and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall() and topSpeed > stats.moveSpeed:
		topSpeed = 0
		return State.BonkAir
	if player.is_on_floor():
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
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashAir
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashUp
		if dashBufferState == State.DashDown and abilities.can_use(PlayerAbilities.list.DashDown):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashDown

	return State.Null

func timers() -> void:
	fallTimer.wait_time = fallTimeTillBonk
	fallTimer.start()
