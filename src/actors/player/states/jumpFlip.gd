extends PlayerInfo


@export var jumpModifier: float = 1.35
@export var transTime: float = 0.5


func enter() -> void:
	EventBus.emit_signal("actionAnnounce", "Boing")
	topSpeed = 0
	neutral_move_direction_logic()
	player.sounds.jump.pitch_scale = jumpModifier
	player.sounds.jump.play()
	player.particles.jumpTriple.restart()
	player.velocity.x = -player.velocity.x
	player.velocity.y = jumpVelocity * jumpModifier
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(player.characterRotate,"rotation", player.facing * 4 * PI, transTime) ## flip,
	tween.tween_property(player.characterCollision,"rotation", player.facing * 4 * PI, transTime)


func exit() -> void:
	player.sounds.jump.pitch_scale = 1
	player.characterRotate.rotation_degrees = 0  #LOOKAT: maybe make a timer tp set back to zero
	player.characterCollision.rotation_degrees = 0 


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	gravity_logic(gravityJump, delta)
	
	if player.neutralMoveDirection:
		neutral_air_momentum_logic(moveSpeed)
	else:
		air_velocity_logic(moveSpeed, accelerationAir, frictionAir, delta)
	
	player.move_and_slide_rotation()
	
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	squash_and_stretch(delta)


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_released("jump"):
		player.velocity.y = max( player.velocity.y, (jumpVelocity * jumpModifier) * percentMinJumpVelocity)
		return State.Fall
	if Input.is_action_just_pressed("dive"):
		return State.Dive
	if Input.is_action_just_pressed("ground pound"):
		return State.GroundPound
	if Input.is_action_just_pressed("dash"):
		return State.Dash

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall() and topSpeed > moveSpeed:
		topSpeed = 0
		return State.BonkAir
	if player.velocity.y > -jumpApexHeight:
		return State.JumpApex
	if player.is_on_floor():
		if player.velocity.x != 0:
			return State.Walk
		else:
			return State.Idle
	if player.is_on_ceiling():
		return State.Fall

	return State.Null
