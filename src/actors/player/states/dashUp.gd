extends PlayerInfo

#TODO: add block break indicator

@export var duration: float = 0.3
@export var durationTimer: Timer
@export var chainTimer: Timer #TODO: visual feedback when chain can be used
@export var particles: GPUParticles2D
@export var soundJetpack: AudioStreamPlayer


func enter() -> void:
	soundJetpack.play()
	GameStats.dashUp += 1
	EventBus.playerDashed.emit()
	player.velocityPrevious = player.velocity
	timers()
	player.animPlayer.queue("Dash Up")
	particles.local_coords = true
	particles.emitting = true
	player.velocity.x = 0
	player.velocity.y = -dashVelocity
	player.ability_mask(CollisionLayers.DashUp, false)


func exit() -> void:
	soundJetpack.stop()
	player.animPlayer.stop()
	particles.local_coords = false
	particles.emitting = false
	player.velocity.y = player.velocity.y/4
	player.ability_mask(CollisionLayers.DashUp, true)


func physics(delta) -> void:
	player.move_and_slide()


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
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_ceiling(): #TODO: bonk ceiling
		return State.Fall
	if durationTimer.is_stopped():
		return State.Fall
	if dashBufferState != State.Null:
		if dashBufferState == State.DashAir and chainTimer.is_stopped() and abilities.chain_check(PlayerAbilities.list.DashSide):
				abilities.currentDashChain += 1
				EventBus.playerActionAnnounce.emit("Chain")
				return State.DashAir
		elif dashBufferState == State.DashUp and chainTimer.is_stopped() and abilities.chain_check(PlayerAbilities.list.DashUp):
				abilities.currentDashChain += 1
				EventBus.playerActionAnnounce.emit("Chain")
				return State.DashUp
		elif dashBufferState == State.DashDown and chainTimer.is_stopped() and abilities.chain_check(PlayerAbilities.list.DashDown):
				abilities.currentDashChain += 1
				EventBus.playerActionAnnounce.emit("Chain")
				return State.DashDown

	return State.Null


func timers() -> void:
	durationTimer.wait_time = duration
	durationTimer.start()
	chainTimer.start()
