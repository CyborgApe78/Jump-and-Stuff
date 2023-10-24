extends PlayerInfo

#TODO: add back

@export_group("Connections")
@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var timerDuration: Timer
@export var timerChain: Timer
@export var particles: GPUParticles2D
@export var soundJetpack: AudioStreamPlayer

@export_group("")
@export var duration: float = 0.3
@export var floorTime: float = 0.1


func enter() -> void:
	abilities.consume(PlayerAbilities.list.Dash, 1)
	soundJetpack.play()
	EventBus.playerDashed.emit()
	player.velocityPrevious = player.velocity
	timers()
	player.animPlayer.queue("Dash Down")
	particles.local_coords = true
	particles.emitting = true
	player.velocity.x = 0
	player.velocity.y = stats.dashSpeed
	player.ability_mask(CollisionLayers.DashDown, false)


func exit() -> void:
	soundJetpack.stop()
	player.animPlayer.stop()
	particles.local_coords = false
	particles.emitting = false
	player.velocity.y = player.velocity.y/4
	player.ability_mask(CollisionLayers.DashDown, true)


func physics(delta) -> void:
	player.move_and_slide()
	velocity.gravity_logic(stats.gravityFall, delta)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justPressedJump:
		if !timerCoyoteJump.is_stopped(): #leave ground, but stil can jump
			timerCoyoteJump.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			return consecutive_jump_logic()
		elif abilities.can_use(PlayerAbilities.list.JumpAir) and !(ground.detectorGroundLeft.is_colliding() or ground.detectorGroundRight.is_colliding()):
			return State.JumpAir
		else:
			timerBufferJump.start()
			player.velocity.y = 0 #Gives more air control when canceling 
			return State.Fall
	if input.justPressedGlide and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Dive):
		return State.Dive
	if input.justPressedDash:
		dash_pressed_buffer()
	if input.justPressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_ceiling():
		return State.Fall
	if player.is_on_floor():
		player.landed()
		if !timerBufferJump.is_stopped():
			timerBufferJump.stop()
			EventBus.helperUsed.emit(Util.helper.bufferJump)
			EventBus.rumble.emit(0.1, 0.3, 0.2)
			return consecutive_jump_logic()
		else:
			if input.pressedCrouch:
				player.animPlayer.stop()
				EventBus.rumble.emit(0.1, 0.2, 0.2)
				return State.Crouch
			elif player.velocity.x != 0:
				EventBus.rumble.emit(0.1, 0.2, 0.2)
				return State.Walk
			else:
				EventBus.rumble.emit(0.1, 0.2, 0.2)
				return State.Idle
	if timerDuration.is_stopped():
		return State.Fall
	if dashBufferState != State.Null:
		if dashBufferState == State.DashAir:
			if timerChain.is_stopped() and abilities.chain_check(PlayerAbilities.list.DashSide):
				abilities.consume(PlayerAbilities.list.DashChain, 1)
				return State.DashAir
			elif abilities.can_use(PlayerAbilities.list.DashSide):
				return State.DashAir
		elif dashBufferState == State.DashUp:
			if timerChain.is_stopped() and abilities.chain_check(PlayerAbilities.list.DashUp):
				abilities.consume(PlayerAbilities.list.DashChain, 1)
				return State.DashUp
			elif abilities.can_use(PlayerAbilities.list.DashUp):
				return State.DashUp
		elif dashBufferState == State.DashDown:
			if timerChain.is_stopped() and abilities.chain_check(PlayerAbilities.list.DashDown):
				abilities.consume(PlayerAbilities.list.DashChain, 1)
				return State.DashDown
			elif abilities.can_use(PlayerAbilities.list.DashDown):
				return State.DashDown

	return State.Null


func timers() -> void:
	timerDuration.wait_time = duration
	timerDuration.start()
	timerChain.start()
