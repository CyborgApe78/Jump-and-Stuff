extends PlayerInfo
#TODO: create place to test jumps

@export var timerLock: Timer

var wallHop: bool
var jumpDirection: int #TODO: change to jumpDirection 


func enter() -> void:
	timerLock.start()
	jumpDirection = player.wall_detection(30)
	EventBus.actionAnnounce.emit("Boing")
	topSpeed = 0
	neutral_move_direction_logic()
	player.sounds.jump.play()
	
	if !player.timers.coyoteJumpWall.is_stopped():
		jumpDirection = player.lastWallDirection
		player.timers.coyoteJumpWall.stop()
	
	if player.moveDirection.y == -1:
		player.velocity = Vector2(100 * -jumpDirection, jumpVelocity * 1.2)
		EventBus.playerInfo.emit("Wall Up")
	elif player.moveDirection.y == 1:
		player.velocity = Vector2(100 * -jumpDirection, 100)
		EventBus.playerInfo.emit("Wall Down")
	elif player.moveDirection.x == 0:
		EventBus.playerInfo.emit("Wall Neutral")
		player.velocity = Vector2(moveSpeed * -jumpDirection, jumpVelocity * 1.2)
	elif player.moveDirection.x == -jumpDirection:
		EventBus.playerInfo.emit("Wall Away")
		player.velocity = Vector2(moveSpeed * -jumpDirection, jumpVelocity)
	elif player.moveDirection.x == jumpDirection:
		EventBus.playerInfo.emit("Wall Towards")
		player.velocity = Vector2(50 * jumpDirection, jumpVelocity)
		wallHop = true
	
	player.particles.jumpWall.restart() #TODO: get direction from wall direction


func exit() -> void:
	pass


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide_rotation()
	#FIXME: create full velocity logic, currently can back to wall sometimes
	if player.moveDirection.x != 0:
		apply_acceleration(accelerationAir, delta)
	elif player.moveDirection.x == 0:
		apply_friction(frictionAir, delta)
	gravity_logic(gravityJump, delta)
	
	#TODO: air velocity func
#	air_velocity_logic(moveSpeed, accelerationAir, frictionAir, delta)
	
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	squash_and_stretch(delta)


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if timerLock.is_stopped():
		if Input.is_action_just_released("jump"):
			player.velocity.y = max( player.velocity.y, jumpVelocity * percentMinJumpVelocity)
			return State.Fall
		if Input.is_action_just_pressed("glide")  and abilities.can_use(PlayerAbilities.list.Glide):
			return State.Glide
		if Input.is_action_just_pressed("dive")  and abilities.can_use(PlayerAbilities.list.Dive):
			return State.Dive
		if Input.is_action_just_pressed("crouch") and abilities.can_use(PlayerAbilities.list.GroundPound):
				return State.GroundPound
		if Input.is_action_just_pressed("dash"):
			dash_pressed_buffer()

	return State.Null


func state_check(delta: float) -> int:
	if timerLock.is_stopped():
		if player.is_on_ceiling():
			consecutive_jump_cancel()
			return State.Fall
		if player.is_on_wall() and topSpeed > moveSpeed: #TODO: wallland if going up
			topSpeed = 0
			return State.BonkAir
		if player.velocity.y > -jumpApexHeight:
			return State.JumpApex
		if player.is_on_floor():
			player.landed()
			if player.velocity.x != 0:
				return State.Walk
			else:
				return State.Idle
		if dashBufferState != State.Null:
			if abilities.can_use(PlayerAbilities.list.DashSide) and dashBufferState == State.DashAir:
				return State.DashAir
			if abilities.can_use(PlayerAbilities.list.DashUp) and dashBufferState == State.DashUp:
				return State.DashUp
			if abilities.can_use(PlayerAbilities.list.DashDown) and dashBufferState == State.DashDown:
				return State.DashDown

	return State.Null
