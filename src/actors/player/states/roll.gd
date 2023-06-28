extends PlayerInfo

#FIXME: got stuck landing on the edge of a platform

@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var timerConsecutiveJump: Timer
@export var timerDuration: Timer
@export var timerChain: Timer

@export var crouchSpeedMin: int = 20
@export var minLongJumpVelocity: int = 30
@export var duration: float = 1.0
@export var refreshPercent: float = 0.8
@export var velocityModifier: float = 1.5
@export var particles: GPUParticles2D
@export var particleChain: GPUParticles2D


var saveConsecutive: bool
var rollVelocity: float
var refreshTime: float
var jumpBoostTime: float


func enter() -> void:
	rollVelocity = moveSpeed * velocityModifier
	player.animPlayer.queue("Roll")
	player.velocityPrevious = player.velocity
	timers()
	particles.emitting = true
	player.velocity.y = 0
	if timerConsecutiveJump.is_stopped():
		saveConsecutive = true
#	player.velocity.x = player.facing * max(rollVelocity, abs(player.velocity.x))


func exit() -> void:
	player.animPlayer.stop()
	timerChain.stop()
	if saveConsecutive:
		timerConsecutiveJump.start() #LOOKAT: fun challange of need high jump but don't have the room, so need to roll or slide
	particles.emitting = false
	saveConsecutive = false


func physics(delta) -> void:
	player.move_and_slide_rotation()
	
	if !player.is_on_floor():
		gravity_logic(gravityFall, delta)
		fall_speed_logic(terminalVelocity)
	
	if  abs(player.velocity.x) < rollVelocity: 
		player.velocity.x = move_toward(abs(player.velocity.x), rollVelocity, (moveSpeed * 3) * delta) * player.facing
	elif abs(player.velocity.x) >= rollVelocity:
		momentum_logic(rollVelocity, false)
	
#	if rad_to_deg(player.groundAngle) < -1: #TOOD: add speed based on ground angle and pull back to slow done
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
	player.animation_speed(.0008)
	align_to_ground()


func sound(delta: float) -> void:
	if player.velocity.x != 0:
		#TODO: need a sound when rolling
		pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump") and (player.is_on_floor() or !timerCoyoteJump.is_stopped()) and !player.crouch_ceiling_detect():
		if timerChain.is_stopped():
			return State.RollJump
		else:
			EventBus.playerActionAnnounce.emit("Early Jump")
			player.velocity.x = player.velocity.x/4
			return State.Jump
	if Input.is_action_just_pressed("slide") and abilities.can_use(PlayerAbilities.list.Slide): #LOOKAT: should you be able to go to slide
		return State.Slide
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashSide):
		abilities.consume(PlayerAbilities.list.DashSide, 1)
		if player.is_on_floor():
			return State.DashGround
		else:
			return State.DashAir
	if Input.is_action_just_pressed("crouch"):
		player.velocity.x = 0
		return State.Crouch
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if Input.is_action_just_pressed("bash") and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim
	if Input.is_action_just_pressed("roll"):
		if timerChain.is_stopped():
			return State.Roll
		else:
			EventBus.playerActionAnnounce.emit("Early Roll")
			return State.Idle

	return State.Null


func state_check(delta: float) -> int:
	if timerDuration.is_stopped():
		if player.is_on_floor(): 
			if player.crouch_ceiling_detect():
				player.velocity.x = 0
				return State.Crouch
			elif Input.is_action_pressed("crouch"):
				player.velocity.x = 0
				return State.Crouch
			elif player.moveDirection.x != 0:
				player.velocity.x = 0
				return State.Walk
			else:
				return State.Idle
		else: #LOOKAT: is this needed  !player.detectorGroundLeft.is_colliding() and !player.detectorGroundRight:
			timerCoyoteJump.start()
			return State.Fall
#	if !player.is_on_floor(): #FIXME: won't work, will keep restarting timer. make a bool
#		timerCoyoteJump.stop()

	return State.Null


func timers() -> void:
	timerDuration.wait_time = duration
	timerDuration.start()
	refreshTime = duration * refreshPercent
	timerChain.wait_time = refreshTime
	timerChain.start()


func _on_chain_timeout() -> void:
	particleChain.restart()
