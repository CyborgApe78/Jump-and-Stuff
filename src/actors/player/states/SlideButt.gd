extends PlayerInfo

## Slide on butt when crouching on a slope


@export_group("Connections")
@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var timerConsecutiveJump: Timer
@export var particles: GPUParticles2D
@export var detector: ShapeCast2D

@export_group("")

var saveTriple: bool
var slideVelocity: float


func enter() -> void:
	player.animPlayer.queue("Crouch")
	player.velocityPrevious = player.velocity
	saveTriple = true if abilities.currentJumpConsec > 1 else false
	particles.emitting = true
	player.velocity.y = 0


func exit() -> void:
	player.animPlayer.stop()
	particles.emitting = false



func physics(delta) -> void:
	player.move_and_slide_rotation()
	timerConsecutiveJump.start()
	
	if !player.is_on_floor():
		velocity.gravity_logic(stats.gravityFall, delta)
		velocity.fall_speed_logic(stats.terminalVelocity)
	
	if rad_to_deg(ground.groundAngle) < -1:
		player.velocity.x -= stats.downHillAccel ## Speed up on down hill
	elif rad_to_deg(ground.groundAngle) > 1:
		player.velocity.x += stats.downHillAccel
	else:
		velocity.apply_friction(stats.frictionGround, delta)


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
#	if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Roll): #TODO: look at adding a roll transition
#		return State.Roll

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall():
		return State.Idle
	if player.is_on_floor() and player.velocity.x == 0:
		if detector.is_colliding():
			return State.Crouch
		elif input.pressedCrouch:
			player.velocity.x = 0
			return State.Crouch
		else:
			return State.Idle
#	if !player.is_on_floor():
#		return State.Fall #TODO: create own fall state
	if dashBufferState != State.Null:
		if dashBufferState == State.DashGround and abilities.can_use(PlayerAbilities.list.DashSide):
			return State.DashGround
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			return State.DashUp

	return State.Null
