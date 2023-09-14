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
	player.grappleHookLine.visible = false


func physics(delta) -> void:
	player.move_and_slide()
	gravity_logic(stats.gravityFall, delta)
	track_top_speed(player.velocity.x)
	if player.targetGrapple != null:
		player.grappleHookLine.set_point_position(1, player.targetGrapple.global_position - player.grappleHookLine.global_position)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justPressedJump:
		if timerCoyoteJump.is_stopped(): #leave ground, but stil can jump
			timerCoyoteJump.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			EventBus.playerActionAnnounce.emit("Coyote Jump")
			return consecutive_jump_logic()
		elif !timerCoyoteJumpWall.is_stopped() and abilities.can_use(PlayerAbilities.list.JumpWall): #leave wall, but stil can jump
			timerCoyoteJumpWall.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			EventBus.playerActionAnnounce.emit("Wall Coyote Jump")
			return State.JumpWall
		elif player.wall_detection(30) != 0 and abilities.can_use(PlayerAbilities.list.JumpWall):
			EventBus.playerActionAnnounce.emit("Near Wall Jump")
			return State.JumpWall
		elif abilities.can_use(PlayerAbilities.list.JumpAir) and !(player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding()):
			return State.JumpAir
		else:
			timerBufferJump.start()
	if input.justPressedGlide and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Dive):
			return State.Dive 
	if input.justPressedCrouch and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
	if input.justPressedDash:
		dash_pressed_buffer()

	return State.Null


func state_check(delta: float) -> int:
	if player.velocity.y > 0:
		return State.Fall
	if player.is_on_wall():
		if topSpeed > stats.moveSpeed:
			topSpeed = 0
			return State.BonkAir
		else:
			return State.WallSlide
	if player.is_on_floor():
		player.landed()
		if input.pressedCrouch:
			player.animPlayer.stop()
			return State.Crouch
		elif player.velocity.x != 0:
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


func grapple_velocity() -> Vector2:
	var playerPosition: Vector2 = player.global_position
	var destination: Vector2 = player.targetGrapple.global_position
	
	var distanceToTarget: float = playerPosition.distance_to(destination)
	var desiredVelocity: Vector2 = playerPosition.direction_to(destination) * stats.dashSpeed #TODO: own stat
	
	if distanceToTarget < slowRadius:
		desiredVelocity *= (distanceToTarget / slowRadius) * .75 + .25
	
	return desiredVelocity


