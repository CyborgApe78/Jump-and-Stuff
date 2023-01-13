extends PlayerInfo
#TODO: falling to long and bonk
#TODO: slow fall while jump held, slightly faster when pressing down

@export var transTime: float = 0.1


func enter() -> void:
	neutral_move_direction_logic()
	player.set_up_direction(Vector2.UP)
	if player.rotation != 0:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(player, "rotation", 0, transTime).from_current()
	player.velocity = player.velocity.rotated(0)


func exit() -> void:
	pass


func physics(delta) -> void:
	if player.test_move(player.global_transform, Vector2(player.velocity.x * delta, 0)):
		player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	gravity_logic(gravityFall, delta)
	fall_speed_logic(terminalVelocity)
	
	if player.neutralMoveDirection:
		neutral_air_momentum_logic(moveSpeed)
	else:
		air_velocity_logic(moveSpeed, accelerationAir, frictionAir)
	
	align_to_ground()


func visual(delta) -> void:
	squash_and_stretch(delta)


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		if !player.timers.coyoteJump.is_stopped(): #leave ground, but stil can jump
			player.timers.coyoteJump.stop()
			EventBus.emit_signal("helperUsed", Util.helper.coyoteJump)
			return consecutive_jump_logic()
		else:
			player.timers.bufferJump.start()
	if Input.is_action_just_pressed("dive"):
		return State.Dive

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_floor():
		player.sounds.land.play()
		player.particles.land.restart()
		player.timers.consecutiveJump.start()
		player.landed()
		if Input.is_action_pressed("crouch"):
			return State.Crouch
		elif player.velocity.x != 0: 
#			if player.neutralMoveDirection:
#				return State.NeutralGround #TODO: keep momentum if jumping
#			else:
			return State.Walk
		else:
			return State.Idle

	return State.Null
