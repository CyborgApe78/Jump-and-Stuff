extends PlayerInfo


#TODO: difference between this and ground pound
@export var duration: float = 0.3
@export var durationTimer: Timer
@export var chainTimer: Timer #TODO: visual feedback when chain can be used
@export var floorTime: float = 0.1
@export var particles: GPUParticles2D


func enter() -> void:
	GameStats.dashDown += 1
	player.velocityPrevious = player.velocity
	timers()
	player.animPlayer.queue("Dash Down")
	particles.emitting = true
	player.velocity.x = 0
	player.velocity.y = dashVelocity / duration #FIXME: should not be based off duration
	player.ability_mask(CollisionLayers.DashDown, false)


func exit() -> void:
	player.animPlayer.stop()
	particles.emitting = false
	player.velocity.y = player.velocity.y/4
	player.ability_mask(CollisionLayers.DashDown, true)


func physics(delta) -> void:
	player.move_and_slide()
	#TODO: increase speed wall falling


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		if !player.timers.coyoteJump.is_stopped(): #leave ground, but stil can jump
			player.timers.coyoteJump.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			return consecutive_jump_logic()
		elif abilities.can_use(PlayerAbilities.list.JumpAir) and !(player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding()): #TODO: ground check to use buffer instead of double jump
			return State.JumpAir
		else:
			player.timers.bufferJump.start()
			return State.Fall
	if Input.is_action_just_pressed("glide")  and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive")  and abilities.can_use(PlayerAbilities.list.Dive):
		return State.Dive
	if Input.is_action_just_pressed("ground_pound") and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook

	return State.Null


func state_check(delta: float) -> int:
	var floorTimer: float
	floorTimer = floorTime
	if player.is_on_ceiling(): #TODO: bonk ceiling
		return State.Fall
	if player.is_on_floor():
		player.landed()
		floorTimer -= delta
		if floorTimer < 0 or durationTimer.is_stopped():
			return State.Idle
#	if durationTimer.is_stopped():
#		return State.Fall
	if dashBufferState != State.Null:
		if dashBufferState == State.DashAir and chainTimer.is_stopped() and abilities.chain_check(PlayerAbilities.list.DashSide):
				abilities.currentDashChain += 1
				EventBus.actionAnnounce.emit("Chain")
				return State.DashAir
		elif dashBufferState == State.DashUp and chainTimer.is_stopped() and abilities.chain_check(PlayerAbilities.list.DashUp):
				abilities.currentDashChain += 1
				EventBus.actionAnnounce.emit("Chain")
				return State.DashUp
		elif dashBufferState == State.DashDown and chainTimer.is_stopped() and abilities.chain_check(PlayerAbilities.list.DashDown):
				abilities.currentDashChain += 1
				EventBus.actionAnnounce.emit("Chain")
				return State.DashDown

	return State.Null


func timers() -> void:
#	durationTimer.wait_time = duration
#	durationTimer.start()
	chainTimer.start()
