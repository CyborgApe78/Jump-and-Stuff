extends PlayerInfo
#TODO: air crouch
#TODO: holding down makes you go through semisolids

@export var fallTimer: Timer
@export var jumpWallSaveTimer: Timer
@export var consecutiveJumpTimer: Timer

@export var jumpHeldSlowModifier: float = 2.0
@export var transTime: float = 0.1
@export var fallTimeTillBonk: float = 0.9
var jumpHeld: bool


func enter() -> void:
	player.velocityPrevious = player.velocity
	timers()
	topSpeed = 0
	neutral_move_direction_logic()
	player.animPlayer.queue("Fall")
	player.set_up_direction(Vector2.UP)
	if player.characterRotate.rotation_degrees != 0:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(player.characterRotate, "rotation_degrees", 0, transTime).from(0)
		tween.tween_property(player.characterCollision, "rotation_degrees", 0, transTime).from(0)
	player.velocity = player.velocity.rotated(0)


func exit() -> void:
	jumpHeld = false


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	
	if player.timers.coyoteJump.is_stopped():
		gravity_logic(gravityFall, delta)
	
	if jumpHeld:
		fall_speed_logic(terminalVelocity / jumpHeldSlowModifier)
	elif  player.moveDirection.y == 1:
		fall_speed_logic(terminalVelocity * 1.5)
	else:
		fall_speed_logic(terminalVelocity)
	
	track_top_speed(player.velocity.x)
	
	if player.neutralMoveDirection:
		neutral_air_momentum_logic(moveSpeed)
	else:
		air_velocity_logic(moveSpeed, accelerationAir, frictionAir, delta)


func visual(delta) -> void:
	squash_and_stretch(delta)
	align_to_ground()
	player.facing_logic()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_pressed("jump"):
		jumpHeld = true
	else: 
		jumpHeld = false
	if Input.is_action_just_pressed("jump"):
		jumpWallSaveTimer.start()
		if !player.timers.coyoteJump.is_stopped(): #leave ground, but stil can jump
			player.timers.coyoteJump.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			EventBus.playerInfo.emit("Coyote Jump")
			return consecutive_jump_logic()
		elif !player.timers.coyoteJumpWall.is_stopped(): #leave wall, but stil can jump
			player.timers.coyoteJumpWall.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			EventBus.playerInfo.emit("Wall Coyote Jump")
			return State.JumpWall
		elif player.wall_detection(30) != 0:
			EventBus.playerInfo.emit("Near Wall Jump")
			return State.JumpWall
		elif abilities.can_use(PlayerAbilities.list.JumpAir) and !(player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding()): #TODO: ground check to use buffer instead of double jump
			return State.JumpAir
		else:
			player.timers.bufferJump.start()
	if Input.is_action_just_pressed("glide") and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive"):
#		if abilities.can_use(PlayerAbilities.list.Roll) and player.check_ground():
#		#TODO: create ground check to see if close to ground and roll instead of dive
#			return State.Roll
		if abilities.can_use(PlayerAbilities.list.Dive):
		#TODO: if note close to ground
			return State.Dive
	if Input.is_action_just_pressed("ground_pound") and abilities.can_use(PlayerAbilities.list.GroundPound): ## if close to ground don't ground pound 
		if player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding():
			return State.Null #LOOKAT: could cause frustration if trying to quickly ground pound
		else:
			return State.GroundPound
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()
	

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall():
		if !jumpWallSaveTimer.is_stopped():
			return State.JumpWall
		if topSpeed > moveSpeed:
			topSpeed = 0
			return State.BonkAir
		else:
			return State.WallSlide
	if player.is_on_floor():
		player.landed()
		if fallTimer.is_stopped():
			return State.BonkGround
		else:
			consecutiveJumpTimer.start()
			if Input.is_action_pressed("crouch"):
				player.animPlayer.stop()
				return State.Crouch
			elif Input.is_action_pressed("slide"):
				player.animPlayer.stop()
				return State.Slide
			elif player.velocity.x != 0:
	#			if player.neutralMoveDirection:
	#				return State.NeutralGround #TODO: keep momentum if jumping
	#			else:
				return State.Walk
			else:
				return State.Idle
	if dashBufferState != State.Null: #TOOD: if !coyoteWallTimer.is_stopped() return WallDash, else Side Dash
		if abilities.can_use(PlayerAbilities.list.DashSide) and dashBufferState == State.DashAir:
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashAir
		if abilities.can_use(PlayerAbilities.list.DashUp) and dashBufferState == State.DashUp:
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashUp
		if abilities.can_use(PlayerAbilities.list.DashDown) and dashBufferState == State.DashDown:
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashDown

	return State.Null


func timers() -> void:
	fallTimer.wait_time = fallTimeTillBonk
	fallTimer.start()
