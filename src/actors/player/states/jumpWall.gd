extends PlayerInfo

#FIXME: coyote wall jump flips sprite away from wall, but returns to face wall without input. adjust facing to match on exit

@export var timerCoyoteJumpWall: Timer
@export var timerLock: Timer
@export var particles: GPUParticles2D
@export var soundeffect: AudioStreamPlayer

var wallHop: bool
var jumpDirection: int


func enter() -> void:
	EventBus.playerJumped.emit()
	timerLock.start()
	jumpDirection = player.wall_detection(30)
	
	neutral_move_direction_logic()
	player.animPlayer.queue("Jump")
	soundeffect.play()
	
	if !timerCoyoteJumpWall.is_stopped():
		jumpDirection = player.lastWallDirection
		timerCoyoteJumpWall.stop()
		
	## up pressed
	if player.moveDirection.y == -1:
		player.characterRig.scale.x = player.wallDirection #TODO: use facing func
		player.velocity = Vector2(100 * -jumpDirection, jumpVelocity * 1.0)
		EventBus.playerActionAnnounce.emit("Wall Up")
	## down pressed
	elif player.moveDirection.y == 1:
		player.characterRig.scale.x = player.wallDirection
		player.velocity = Vector2(300 * -jumpDirection, 100)
		EventBus.playerActionAnnounce.emit("Wall Down")
	## no directional input
	elif player.moveDirection.x == 0:
		player.characterRig.scale.x = -player.wallDirection
		EventBus.playerActionAnnounce.emit("Wall Neutral")
		player.velocity = Vector2(max(moveSpeed / 1.5 , abs(player.velocityPrevious.x)) * -jumpDirection, jumpVelocity * 0.9)
	## away from wall pressed
	elif player.moveDirection.x == -jumpDirection:
		player.characterRig.scale.x = -player.wallDirection
		EventBus.playerActionAnnounce.emit("Wall Away")
		player.velocity = Vector2(moveSpeed * -jumpDirection, jumpVelocity * 0.7)
	## towards from wall pressed
	elif player.moveDirection.x == jumpDirection: 
		player.characterRig.scale.x = player.wallDirection
		EventBus.playerActionAnnounce.emit("Wall Towards") 
		player.velocity = Vector2(200 * -jumpDirection, jumpVelocity * 0.8)
		wallHop = true
	
	particles.restart()
	topSpeed = 0


func exit() -> void:
	player.animPlayer.stop()


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide_rotation()
	#FIXME: create full velocity logic, currently can back to wall sometimes, look at long jump state change
	if timerLock.is_stopped():
		if player.neutralMoveDirection:
			neutral_air_momentum_logic(moveSpeed)
		else:
			if player.moveDirection.x != 0:
				apply_acceleration(moveSpeed, accelerationAir, delta)
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
		if Input.is_action_just_pressed("bash") and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
			return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if timerLock.is_stopped():
		if player.is_on_ceiling():
			consecutive_jump_cancel()
			return State.Fall
		if player.is_on_wall() and topSpeed > moveSpeed:
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
