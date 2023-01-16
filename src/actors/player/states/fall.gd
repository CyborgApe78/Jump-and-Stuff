extends PlayerInfo
#TODO: slow fall while jump held, slightly faster when pressing down

@onready var fallTimer: Timer = $FallTimeMax

@export var jumpHeldSlowModifier: float = 2.0
@export var transTime: float = 0.1
@export var fallTimeTillBonk: float = 0.9

var jumpHeld: bool


func enter() -> void:
	fallTimer.wait_time = fallTimeTillBonk
	fallTimer.start()
	topSpeed = 0
	neutral_move_direction_logic()
	player.set_up_direction(Vector2.UP)
	if player.rotation != 0:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(player, "rotation", 0, transTime).from_current()
	player.velocity = player.velocity.rotated(0)


func exit() -> void:
	jumpHeld = false


func physics(delta) -> void:
	if player.test_move(player.global_transform, Vector2(player.velocity.x * delta, 0)):
		player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	
	if jumpHeld:
		gravity_logic(gravityFall / jumpHeldSlowModifier, delta)
		fall_speed_logic(terminalVelocity / jumpHeldSlowModifier)
	else:
		gravity_logic(gravityFall, delta)
		fall_speed_logic(terminalVelocity)
	
	track_top_speed(player.velocity.x)
	
	if player.neutralMoveDirection:
		neutral_air_momentum_logic(moveSpeed)
	else:
		air_velocity_logic(moveSpeed, accelerationAir, frictionAir)


func visual(delta) -> void:
	squash_and_stretch(delta)
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_pressed("jump"):
		jumpHeld = true
	else: 
		jumpHeld = false
	if Input.is_action_just_pressed("jump"):
		if !player.timers.coyoteJump.is_stopped(): #leave ground, but stil can jump
			player.timers.coyoteJump.stop()
			EventBus.emit_signal("helperUsed", Util.helper.coyoteJump)
			return consecutive_jump_logic()
		else:
			player.timers.bufferJump.start()
	if Input.is_action_just_pressed("dive"):
		return State.Dive
	if Input.is_action_just_pressed("ground pound"):
		return State.GroundPound

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall() and topSpeed > moveSpeed:
		topSpeed = 0
		return State.BonkAir
	if player.is_on_floor():
		if fallTimer.is_stopped():
			return State.BonkGround
		else:
			player.sounds.land.play()
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
