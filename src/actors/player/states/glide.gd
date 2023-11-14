extends PlayerInfo

#LOOKAT: make 2, one for slow fall, other for coming out of side dashes more like buzz lightyear mixed with mario cape
#LOOKAT: look into mario wonder glide

@export_group("Connections")
@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var timerConsecutiveJump: Timer

@export_group("")
@export var transTime: float = 0.1


func enter() -> void:
	player.velocityPrevious = player.velocity
	neutral_move_direction_logic()
	player.animPlayer.play("Glide")
	player.set_up_direction(Vector2.UP)
	if player.characterRotate.rotation_degrees != 0:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(player.characterRotate, "rotation_degrees", 0, transTime).from(0)
		tween.tween_property(player.characterCollision, "rotation_degrees", 0, transTime).from(0)


func exit() -> void:
	player.animPlayer.stop()


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(stats.jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(stats.jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	
	if player.neutralMoveDirection:
		neutral_air_momentum_logic(stats.moveSpeed * stats.glideVelocityModifier)
	else:
		velocity.air_velocity_logic(stats.moveSpeed * stats.glideVelocityModifier, stats.accelerationAir, stats.frictionAir, delta)
	
	if player.inWind:
		player.velocity.y = player.windVelocity.y
	else:
		velocity.gravity_logic(stats.gravityGlide, delta)
		velocity.fall_speed_logic(stats.terminalGlideVelocity)
	
	velocity.track_top_speed(player.velocity.x)
	
	


func visual(delta) -> void:
	align_to_ground()
	player.facing_logic(input.lastMoveDirection.x)


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justReleasedGlide:
		return State.Fall
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
	if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Dive):
		return State.Dive
	if input.justPressedCrouch and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
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
		player.landed()
		timerConsecutiveJump.start()
		if input.pressedCrouch:
			return State.Crouch
		elif player.velocity.x != 0: 
			return State.Walk
		else:
			return State.Idle
	if dashBufferState != State.Null:
		if dashBufferState == State.DashAir and abilities.can_use(PlayerAbilities.list.DashSide):
			return State.DashAir
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			return State.DashUp
		if dashBufferState == State.DashDown and abilities.can_use(PlayerAbilities.list.DashDown):
			return State.DashDown

	return State.Null
