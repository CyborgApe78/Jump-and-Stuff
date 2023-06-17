extends PlayerInfo


@export var timerCoyoteJump: Timer
@export var timerCoyoteJumpWall: Timer
@export var timerBufferJump: Timer

const slowRadius: = 2 * Util.tileSize


func enter() -> void:
	player.velocity = grapple_velocity()
	player.grappleHookLine.visible = true


func exit() -> void:
	player.targetGrapple = null
	player.grappleHookLine.visible = false #FIXME: needs to disappear when reached


func physics(delta) -> void:
	player.move_and_slide()
	gravity_logic(gravityFall, delta)
	track_top_speed(player.velocity.x)
	if player.targetGrapple != null:
		player.grappleHookLine.set_point_position(1, player.targetGrapple.global_position - player.grappleHookLine.global_position)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		if timerCoyoteJump.is_stopped(): #leave ground, but stil can jump
			timerCoyoteJump.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			EventBus.playerActionAnnounce.emit("Coyote Jump")
			return consecutive_jump_logic()
		elif !timerCoyoteJumpWall.is_stopped(): #leave wall, but stil can jump
			timerCoyoteJumpWall.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			EventBus.playerActionAnnounce.emit("Wall Coyote Jump")
			return State.JumpWall
		elif player.wall_detection(30) != 0:
			EventBus.playerActionAnnounce.emit("Near Wall Jump")
			return State.JumpWall
		elif abilities.can_use(PlayerAbilities.list.JumpAir) and !(player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding()): #TODO: ground check to use buffer instead of double jump
			return State.JumpAir
		else:
			timerBufferJump.start()
	if Input.is_action_just_pressed("glide") and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive"):
#		if abilities.can_use(PlayerAbilities.list.Roll) and player.check_ground():
#		#TODO: create ground check to see if close to ground and roll instead of dive
#			return State.Roll
		if abilities.can_use(PlayerAbilities.list.Dive):
			return State.Dive 
	if Input.is_action_just_pressed("ground_pound") and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashSide):
		abilities.consume(PlayerAbilities.list.DashSide, 1)
		return State.DashAir

	return State.Null


func state_check(delta: float) -> int:
	if player.velocity.y > 0:
		return State.Fall
	if player.is_on_wall():
		if topSpeed > moveSpeed:
			topSpeed = 0
			return State.BonkAir
		else:
			return State.WallSlide
	if player.is_on_floor():
		player.landed()
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

	return State.Null


func grapple_velocity() -> Vector2:
	var playerPosition: Vector2 = player.global_position
	var destination: Vector2 = player.targetGrapple.global_position
	
	var distanceToTarget: float = playerPosition.distance_to(destination)
	var desiredVelocity: Vector2 = playerPosition.direction_to(destination) * dashVelocity #TODO: create own velocity
	
	if distanceToTarget < slowRadius:
		desiredVelocity *= (distanceToTarget / slowRadius) * .75 + .25
	
	return desiredVelocity


