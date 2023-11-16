extends PlayerInfo

#TODO: roll on curved walls

@export_group("Connections")
@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var timerConsecutiveJump: Timer
@export var timerDuration: Timer
@export var timerChain: Timer
@export var particles: GPUParticles2D
@export var particleChain: GPUParticles2D
@export var detector: ShapeCast2D

@export_group("")
@export var crouchSpeedMin: int = 20
@export var minLongJumpVelocity: int = 30 #LOOKAT: grabbing from stats 
@export var duration: float = 0.8
@export var refreshPercent: float = 0.8

var saveConsecutive: bool
var refreshTime: float
var jumpBoostTime: float


func enter() -> void:
	EventBus.playerRolled.emit()
	
	player.velocityPrevious = player.velocity
	
	player.velocity.x = player.facing * max(stats.moveSpeed * stats.rollVelocityModifier, abs(player.velocity.x)) #LOOKAT: should there be accel
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
		saveConsecutive = false
	particles.emitting = false
	


func physics(delta) -> void:
	player.move_and_slide_rotation()
	
	if !player.is_on_floor():
		velocity.gravity_logic(stats.gravityFall, delta)
		velocity.fall_speed_logic(stats.terminalVelocity)
	
	#TODO: needs hori movement code when !isonfloor
	if rad_to_deg(ground.groundAngle) < -1: #TODO: create own accel and deccel
		if sign(player.velocity.x) == -1:
			player.velocity.x -= stats.rollDownHillAccel * delta ## Speed up on down hill
		else:
			player.velocity.x -= stats.rollDownHillAccel * delta ## Slow on up hill
#			velocity.apply_friction(frictionGround * upHillFrictionModifier, delta) 
	elif rad_to_deg(ground.groundAngle) > 1:
		if sign(player.velocity.x) == 1:
			player.velocity.x += stats.rollDownHillAccel * delta  ## Speed up on down hill
		else:
			player.velocity.x += stats.rollDownHillAccel * delta ## Slow on up hill
#			velocity.apply_friction(stats,rollDownHillAccel, delta) 
	elif timerDuration.is_stopped():
		velocity.apply_friction(stats.frictionRoll, delta)


func visual(delta) -> void:
	player.animation_speed(.0008)
	align_to_ground()


func sound(delta: float) -> void:
	if player.velocity.x != 0:
		#TODO: need a sound when rolling
		pass


func handle_input(event: InputEvent) -> int:
	if input.justPressedJump:
		if detector.is_colliding():
			return State.JumpCrouch
		else:
			if timerChain.is_stopped() and !timerDuration.is_stopped() and abilities.can_use(PlayerAbilities.list.JumpRoll):
				return State.RollJump
			else:
				EventBus.playerActionAnnounce.emit("Early Jump")
				player.velocity.x = player.velocity.x/4
				return State.Jump
	if input.justPressedDash and abilities.can_use(PlayerAbilities.list.DashRoll):
		return State.RollDash
	if input.justPressedCrouch:
		player.velocity.x = 0
		return State.Crouch
	if input.justPressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim
	if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Roll):
		saveConsecutive = false
		if timerDuration.is_stopped():
			return State.Roll
		else:
			if timerChain.is_stopped():
				player.velocity.x = stats.moveSpeed * stats.rollChainVelocityModifier
				return State.Roll 

	return State.Null


func state_check(delta: float) -> int:
	if timerDuration.is_stopped() and abs(player.velocity.x) < 10 and abs(ground.groundAngle) < 0.01:
		if player.is_on_floor(): 
			if detector.is_colliding():
				player.velocity.x = 0
				return State.Crouch
			elif input.pressedCrouch:
				player.velocity.x = 0
				return State.Crouch
			elif input.moveDirection.x != 0:
				player.velocity.x = 0
				return State.Walk
			else:
				return State.Idle
		else:
			timerCoyoteJump.start()
			return State.Fall

	return State.Null


func timers() -> void:
	if !timerConsecutiveJump.is_stopped():
		saveConsecutive = true
	timerDuration.wait_time = duration
	timerDuration.start()
	refreshTime = duration * refreshPercent
	timerChain.wait_time = refreshTime
	timerChain.start()


func _on_chain_timeout() -> void:
	particleChain.restart()
