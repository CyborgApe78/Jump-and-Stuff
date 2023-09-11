extends PlayerInfo

#LOOKAT: merge with jump
@export var timerCoyoteJump: Timer
@export var timerConsecutiveJump: Timer
@export var soundeffect: AudioStreamPlayer

@export var jumpModifier: float = 0.25
@export var particles: GPUParticles2D


func enter() -> void:
	EventBus.playerJumped.emit()
	abilities.consume(PlayerAbilities.list.JumpConsec, 1)
	topSpeed = 0
	neutral_move_direction_logic()
	player.animPlayer.queue("Jump")
	soundeffect.pitch_scale = 0.25 * abilities.currentJumpConsec + 1 
	soundeffect.play()
	particles.restart() #TODO: adjust based on consec number
	if abilities.currentJumpConsec == 1: #TODO:remove this from resource and put on node
		player.velocity.y = stats.jumpDoubleVelocity
	else:
		player.velocity.y = stats.jumpTripleVelocity
	timerCoyoteJump.stop()
	timerConsecutiveJump.stop()
	
	if abilities.currentJumpConsec > 1: #TODO: move to animation
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
		tween.tween_property(player.characterRotate,"rotation", player.facing * abilities.currentJumpConsec * PI, 0.5) ## flip,
		tween.tween_property(player.characterCollision,"rotation", player.facing * abilities.currentJumpConsec * PI, 0.5) #FIXME: leaves upside down on odd numbers


func exit() -> void:
	player.animPlayer.stop()
	soundeffect.pitch_scale = 1
	player.characterRotate.rotation_degrees = 0 
	player.characterCollision.rotation_degrees = 0
	if abilities.currentJumpConsec == abilities.maxJumpConsec:
		abilities.reset(PlayerAbilities.list.JumpConsec)
		player.jumped = false


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(stats.jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(stats.jumpCornerCorrectionVertical, delta)
	
	gravity_logic(stats.gravityJump, delta)
	
	if player.neutralMoveDirection:
		neutral_air_momentum_logic(stats.moveSpeed)
	else:
		air_velocity_logic(stats.moveSpeed, stats.accelerationAir, stats.frictionAir, delta)
	
	player.move_and_slide_rotation()
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	squash_and_stretch(delta)
	player.facing_logic()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_released("jump"):
		player.velocity.y = max( player.velocity.y, stats.jumpVelocity * stats.percentMinJumpVelocity)
		if player.velocity.y > (stats.jumpVelocity * ((jumpModifier * abilities.currentJumpConsec) + 1)) * stats.percentKeepJumpConsecutive: ## needs to be a percent of full jump to keep it going
			consecutive_jump_cancel()
		return State.Fall
	if Input.is_action_just_pressed("glide") and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive") and abilities.can_use(PlayerAbilities.list.Dive):
		return State.Dive
	if Input.is_action_just_pressed("ground_pound") and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if Input.is_action_just_pressed("bash") and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_ceiling():
		consecutive_jump_cancel()
		return State.Fall
	if player.is_on_wall() and topSpeed > stats.moveSpeed:
		topSpeed = 0
		return State.BonkAir
#		elif player.moveDirection.x == player.wallDirection:
#			return State.WallSlide
	if player.velocity.y > -stats.jumpApexHeight:
		return State.JumpApex
	if player.is_on_floor():
		player.landed()
		EventBus.rumble.emit(0.1, 0.2, 0.2)
		if player.velocity.x != 0:
			return State.Walk
		else:
			return State.Idle
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
