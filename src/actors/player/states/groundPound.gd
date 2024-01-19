extends PlayerInfo


@export_group("Connections")
@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var timerSemisolidReset: Timer
@export var detector: ShapeCast2D

@export_group("")
@export var transTime: float = 0.1


func enter() -> void:
	abilities.consume(PlayerAbilities.listUse.GroundPound, 1)
	player.velocity.y = stats.gpVelocity
	player.animPlayer.queue("Ground Pound")
	if player.characterRotate.rotation_degrees != 0:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(player.characterRotate, "rotation_degrees", 0, transTime).from(0)
		tween.tween_property(player.characterCollision, "rotation_degrees", 0, transTime).from(0)
	player.ability_mask(CollisionLayers.GroundPound, false)


func exit() -> void:
	player.characterRotate.rotation_degrees = 0 
	player.characterCollision.rotation_degrees = 0 
	player.ability_mask(CollisionLayers.GroundPound, true)


func physics(delta) -> void:
	player.attempt_vertical_corner_correction(stats.jumpCornerCorrectionVertical, delta)
	player.move_and_slide()
	
	if player.velocity.y < 0:
		velocity.gravity_logic(stats.gravityGPFloat, delta)
	else:
		velocity.gravity_logic(stats.gravityGP, delta)
	velocity.fall_speed_logic(stats.terminalGPVelocity)
	
	player.velocity.x = 0
#	if input.pressGroundPound: ## could use this bounce along the ground
#		player.velocity.x = 0
#	else:
#		velocity.air_velocity_logic(moveSpeed, accelerationAir, frictionAir, delta)


func visual(delta) -> void:
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if !player.inWater: ##TODO: change this to a match state
		if input.pressedDown:
			player.set_collision_mask_value(CollisionLayers.Semisolid, false)
			timerSemisolidReset.stop()
		if input.justPressedDown:
			timerSemisolidReset.start()
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
		if input.justPressedGlide and abilities.can_use(PlayerAbilities.list.Glide):
			return State.Glide
		if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Dive):
			return State.DiveHop
		if input.justPressedDash:
			dash_pressed_buffer()
		if input.justPressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
			return State.GrappleHook
		if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
			return State.BashAim
	else:
		if input.justPressedJump:
			return State.Swim

	return State.Null


func state_check(delta: float) -> int:
	if !player.is_on_floor():
		player.GPMaxVelocity = player.velocity
	if player.is_on_floor():
		if player.inWater:
			return State.Swim
		EventBus.playerLanded.emit()
		if !input.pressedCrouch and abilities.can_use(PlayerAbilities.list.GroundPoundBounce):
			player.landed()
			return State.GroundPoundBounce
		else:
			return State.GroundPoundLand
	if dashBufferState != State.Null:
		if dashBufferState == State.DashAir and abilities.can_use(PlayerAbilities.list.DashSide):
			return State.DashAir
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			return State.DashUp
		if dashBufferState == State.DashDown and abilities.can_use(PlayerAbilities.list.DashDown):
			return State.DashDown

	return State.Null
