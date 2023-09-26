extends PlayerInfo


@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var timerConsecutiveJump: Timer
@export var durationTimer: Timer
@export var particles: GPUParticles2D
@export var detector: ShapeCast2D

@export var velocityModifier: float = 1.25
@export var duration: float = 0.3

var saveTriple: bool
var slideVelocity: float


func enter() -> void:
	slideVelocity = stats.moveSpeed * velocityModifier
	player.animPlayer.queue("Slide")
	player.velocityPrevious = player.velocity
	saveTriple = true if abilities.currentJumpConsec > 1 else false
	particles.emitting = true
	player.velocity.y = 0
	player.velocity.x = player.facing * max(slideVelocity, abs(player.velocity.x))
	timers()


func exit() -> void:
	player.animPlayer.stop()
	particles.emitting = false
#	if abs(player.velocityPrevious.x) < abs(player.velocity.x):
#		player.velocity.x = player.velocityPrevious.x


func physics(delta) -> void:
	player.move_and_slide_rotation()
	timerConsecutiveJump.start()
	
	if !player.is_on_floor():
		gravity_logic(stats.gravityFall, delta)
		fall_speed_logic(stats.terminalVelocity)
	
#	if abs(player.velocity.x) < slideVelocity: 
#		player.velocity.x = move_toward(abs(player.velocity.x), slideVelocity, (moveSpeed * 6) * delta) * player.facing
#	elif abs(player.velocity.x) >= slideVelocity:
#		momentum_logic(slideVelocity, false)
	
	if rad_to_deg(ground.groundAngle) < -1:
		if sign(player.velocity.x) == -1:
			player.velocity.x -= stats.downHillAccel ## Speed up on down hill
		else:
			apply_friction(stats.frictionGround * stats.upHillFrictionModifier, delta) ## Slow on up hill
	elif rad_to_deg(ground.groundAngle) > 1:
		if sign(player.velocity.x) == 1:
			player.velocity.x += stats.downHillAccel
		else:
			apply_friction(stats.frictionGround * stats.upHillFrictionModifier, delta)
	else:
		momentum_logic(slideVelocity, false)


func visual(delta) -> void:
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if !detector.is_colliding():
		if input.justPressedJump:
			if player.is_on_floor() or !timerCoyoteJump.is_stopped():
				return consecutive_jump_logic() #TODO: special jump state
			if !player.is_on_floor() and wall.wallDirection != 0 and abilities.can_use(PlayerAbilities.list.JumpLong): #FIXME: this needs to check wall and velocity direction are correct
				return State.JumpLong #TODO: own jump state
			else:
				timerBufferJump.start()
		if input.justPressedDash:
			dash_pressed_buffer()
	if input.justPressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim
#	if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Roll): #LOOKAT: should you be able to go to slide
#		return State.Roll

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall():
		return State.Idle
	if durationTimer.is_stopped(): #TODO: upgrade that keeps sliding to
		if player.is_on_floor():
			if detector.is_colliding():
				player.velocity.x = 0
				return State.Crouch
			elif input.pressedCrouch:
				player.velocity.x = 0
				return State.Crouch
			elif player.moveDirection.x != 0:
				return State.Walk
			else:
				return State.Idle
		else:
			return State.Fall
	if dashBufferState != State.Null:
		if dashBufferState == State.DashGround and abilities.can_use(PlayerAbilities.list.DashSide):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashGround
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashUp

	return State.Null

func timers() -> void:
	durationTimer.wait_time = duration
	durationTimer.start()
