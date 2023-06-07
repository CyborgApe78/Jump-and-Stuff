extends PlayerInfo
#TODO: charRig Rotate needs to move to center of crouched and other one block states

@export var crouchSpeedMin: int = 20
@export var minLongJumpVelocity: int = 30
@export var duration: float = 0.5
@export var refreshPercent: float = 0.8
@export var velocityModifier: float = 1.5
@export var durationTimer: Timer
@export var refreshTimer: Timer
@export var jumpBoostTimer: Timer
@export var particles: GPUParticles2D


var crouchReleased: bool = false
var saveTriple: bool
var rollVelocity: float
var refreshTime: float
var jumpBoostTime: float


func enter() -> void:
	rollVelocity = moveSpeed * velocityModifier
	crouchReleased = false
	player.animPlayer.queue("Roll")
	player.velocityPrevious = player.velocity
	saveTriple = true if abilities.currentJumpConsec > 1 else false
	timers()
	particles.emitting = true
	player.velocity.y = 0
#	player.velocity.x = player.facing * max(rollVelocity, abs(player.velocity.x))


func exit() -> void:
	player.animPlayer.stop()
	particles.emitting = false


func physics(delta) -> void:
	player.move_and_slide_rotation()
	
	player.timers.consecutiveJump.start()
	
	if !player.is_on_floor():
		gravity_logic(gravityFall, delta)
		fall_speed_logic(terminalVelocity)
	
	if  abs(player.velocity.x) < rollVelocity: 
		player.velocity.x = move_toward(abs(player.velocity.x), rollVelocity, (moveSpeed * 6) * delta) * player.facing
	elif abs(player.velocity.x) >= rollVelocity:
		momentum_logic(rollVelocity, false)
	
#	if rad_to_deg(player.groundAngle) < -1:
#		if sign(player.velocity.x) == -1:
#			player.velocity.x -= downHillAccel ## Speed up on down hill
#		else:
#			apply_friction(frictionGround * upHillFrictionModifier, delta) ## Slow on up hill
#	if rad_to_deg(player.groundAngle) > 1:
#		if sign(player.velocity.x) == 1:
#			player.velocity.x += downHillAccel #TODO: make like friction func, need a top speed or make this function
#		else:
#			apply_friction(frictionGround * upHillFrictionModifier, delta)
#	else:
#		momentum_logic(rollVelocity, false)


func visual(delta) -> void:
	align_to_ground()


func sound(delta: float) -> void:
	if player.velocity.x != 0:
		#TODO: need a sound when rolling
		pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump") and (player.is_on_floor() or !player.timers.coyoteJump.is_stopped()) and !player.crouch_ceiling_detect():
		if jumpBoostTimer.is_stopped():
			return State.JumpLong #TODO: special jump state
		else:
			EventBus.playerActionAnnounce.emit("Early Jump")
			player.velocity.x = player.velocity.x/4
			return State.Jump
	if Input.is_action_just_pressed("slide") and abilities.can_use(PlayerAbilities.list.Slide): #LOOKAT: should you be able to go to slide
		return State.Slide
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()
	if Input.is_action_just_pressed("crouch"):
		crouchReleased = false
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if Input.is_action_pressed("crouch") and Input.is_action_pressed("roll"): #TODO: add timer that is just shorter than duration
		if refreshTimer.is_stopped():
			return State.Roll
		else:
			EventBus.playerActionAnnounce.emit("Early Roll")
			return State.Idle

	return State.Null


func state_check(delta: float) -> int:
	if durationTimer.is_stopped():
		if player.is_on_floor(): 
			if player.crouch_ceiling_detect():
				player.velocity.x = 0
				return State.Crouch
			elif Input.is_action_pressed("crouch"):
				player.velocity.x = 0
				return State.Crouch
			elif player.moveDirection.x != 0:
				return State.Walk #lookat: interaction with speedboost
			else:
				return State.Idle
		else: #LOOKAT: is this needed  !player.detectorGroundLeft.is_colliding() and !player.detectorGroundRight:
			player.timers.coyoteJump.start()
			return State.Fall
#	if !player.is_on_floor(): #FIXME: won't work, will keep restarting timer. make a bool
#		player.timers.coyoteJump.stop()

	return State.Null


func timers() -> void:
	durationTimer.wait_time = duration
	durationTimer.start()
	refreshTime = duration * refreshPercent
	refreshTimer.wait_time = refreshTime
	refreshTimer.start()
	jumpBoostTime = duration * refreshPercent
	jumpBoostTimer.start()
