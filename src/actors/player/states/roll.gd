extends PlayerInfo

#TODO: lots of number tweeaking
#TODO: max roll speed

@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var timerConsecutiveJump: Timer
@export var timerDuration: Timer
@export var timerChain: Timer
@export var particles: GPUParticles2D
@export var particleChain: GPUParticles2D
@export var detector: ShapeCast2D

@export var crouchSpeedMin: int = 20
@export var minLongJumpVelocity: int = 30
@export var duration: float = 0.8
@export var refreshPercent: float = 0.8
@export var modifierVelocity: float = 1.25
@export var modifierChainBoost: float = 1.5

var saveConsecutive: bool
var rollVelocity: float
var velocityChainBoost: float
var naxRoll
var refreshTime: float
var jumpBoostTime: float


func enter() -> void:
	EventBus.playerRolled.emit()
	
	rollVelocity = moveSpeed * modifierVelocity
	velocityChainBoost = moveSpeed * modifierChainBoost
	
	player.velocityPrevious = player.velocity
	if timerConsecutiveJump.is_stopped():
		saveConsecutive = true
		
	player.velocity.x = player.facing * max(rollVelocity, abs(player.velocity.x))
	player.velocity.y = 0
	
	player.animPlayer.queue("Roll")
	
	particles.emitting = true
	
	timers()


func exit() -> void:
	player.animPlayer.stop()
	timerChain.stop()
	timerDuration.stop()
	if saveConsecutive:
		timerConsecutiveJump.start() #LOOKAT: fun challange of need high jump but don't have the room, so need to roll or slide
	particles.emitting = false
	saveConsecutive = false


func physics(delta) -> void:
	player.move_and_slide_rotation()
	
	if !player.is_on_floor():
		gravity_logic(gravityFall, delta)
		fall_speed_logic(terminalVelocity)
	
	#TODO: needs hori movement code when !isonfloor
	if rad_to_deg(player.groundAngle) < -1: #TODO: create own accel and deccel
		if sign(player.velocity.x) == -1:
			player.velocity.x -= downHillAccel ## Speed up on down hill
		else:
			player.velocity.x -= downHillAccel ## Slow on up hill
#			apply_friction(frictionGround * upHillFrictionModifier, delta) 
	elif rad_to_deg(player.groundAngle) > 1:
		if sign(player.velocity.x) == 1:
			player.velocity.x += downHillAccel  ## Speed up on down hill
		else:
			player.velocity.x += downHillAccel ## Slow on up hill
#			apply_friction(frictionGround * upHillFrictionModifier, delta) 
	elif timerDuration.is_stopped():
		apply_friction(frictionGround, delta) #TODO: own friction


func visual(delta) -> void:
	player.animation_speed(.0008)
	align_to_ground()


func sound(delta: float) -> void:
	if player.velocity.x != 0:
		#TODO: need a sound when rolling
		pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		if detector.is_colliding():
			return State.Crouch #LOOKAT: removing cancel
		else:
			if timerChain.is_stopped() and !timerDuration.is_stopped() and abilities.can_use(PlayerAbilities.list.JumpRoll):
				return State.RollJump
			else:
				EventBus.playerActionAnnounce.emit("Early Jump")
				player.velocity.x = player.velocity.x/4
				return State.Jump
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashSide) and !detector.is_colliding():
		#TODO: create state of boosted roll
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
	if Input.is_action_just_pressed("roll") and abilities.can_use(PlayerAbilities.list.Roll):
		if timerDuration.is_stopped():
			return State.Roll
		else:
			if timerChain.is_stopped():
				player.velocity.x = velocityChainBoost
				return State.Roll 

	return State.Null


func state_check(delta: float) -> int:
	if timerDuration.is_stopped() and abs(player.velocity.x) < 10 and abs(player.groundAngle) < 0.01: #fixme: stops player from rolling, need timer
		if player.is_on_floor(): 
			if detector.is_colliding():
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
		else:
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
