extends PlayerInfo

#FIXME: coyote wall jump flips sprite away from wall, but returns to face wall without input. adjust facing to match on exit

@export var timerLock: Timer
@export var particles: GPUParticles2D

var wallHop: bool
var jumpDirection: int #TODO: change to jumpDirection 


func enter() -> void:
	GameStats.jumps += 1 
	EventBus.playerJumped.emit()
	timerLock.start()
	jumpDirection = player.wall_detection(30)
	topSpeed = 0
	neutral_move_direction_logic()
	player.animPlayer.queue("Jump")
	player.sounds.jump.play()
	
	if !player.timers.coyoteJumpWall.is_stopped():
		jumpDirection = player.lastWallDirection
		player.timers.coyoteJumpWall.stop()
	
	if player.moveDirection.y == -1: ## up pressed
		player.characterRig.scale.x = player.wallDirection #TODO: make a function
		player.velocity = Vector2(500 * -jumpDirection, jumpVelocity * 1.3)
		EventBus.playerActionAnnounce.emit("Wall Up")
	elif player.moveDirection.y == 1: ## down pressed
		player.characterRig.scale.x = player.wallDirection
		player.velocity = Vector2(300 * -jumpDirection, 100)
		EventBus.playerActionAnnounce.emit("Wall Down")
	elif player.moveDirection.x == 0: ## no directional input
		player.characterRig.scale.x = -player.wallDirection
		EventBus.playerActionAnnounce.emit("Wall Neutral")
		player.velocity = Vector2(moveSpeed / 1.5 * -jumpDirection, jumpVelocity * 1.1)
	elif player.moveDirection.x == -jumpDirection: ## away from wall pressed
		player.characterRig.scale.x = -player.wallDirection
		EventBus.playerActionAnnounce.emit("Wall Away")
		player.velocity = Vector2(moveSpeed * -jumpDirection, jumpVelocity)
	elif player.moveDirection.x == jumpDirection: ## towards from wall pressed
		player.characterRig.scale.x = player.wallDirection
		EventBus.playerActionAnnounce.emit("Wall Towards") 
		player.velocity = Vector2(50 * jumpDirection, jumpVelocity)
		wallHop = true
	
	particles.restart() #TODO: get direction from wall direction


func exit() -> void:
	player.animPlayer.stop()


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
		if Input.is_action_just_pressed("ground_pound") and abilities.can_use(PlayerAbilities.list.GroundPound): 
			return State.GroundPound
		if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashSide):
			abilities.consume(PlayerAbilities.list.DashSide, 1)
			return State.DashAir
		if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
			return State.GrappleHook

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

	return State.Null
