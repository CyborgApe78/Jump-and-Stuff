extends PlayerInfo


@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var timerDuration: Timer
@export var timerChain: Timer
@export var particles: GPUParticles2D
@export var soundJetpack: AudioStreamPlayer

@export var duration: float = 0.3


func enter() -> void:
	soundJetpack.play()
	EventBus.playerDashed.emit()
	player.velocityPrevious = player.velocity
	timers()
	player.animPlayer.queue("Dash Up")
	particles.local_coords = true
	particles.emitting = true
	player.velocity.x = 0
	if player.is_on_floor():
		player.velocity.y = -dashVelocity * 1.25
	else:
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
		if !timerCoyoteJump.is_stopped(): #leave ground, but stil can jump
			timerCoyoteJump.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			return consecutive_jump_logic()
		elif abilities.can_use(PlayerAbilities.list.JumpAir) and !(player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding()):
			return State.JumpAir
		else:
			timerBufferJump.start()
			return State.Fall
	if Input.is_action_just_pressed("glide") and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive") and abilities.can_use(PlayerAbilities.list.Dive):
		return State.Dive
	if Input.is_action_just_pressed("ground_pound") and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if Input.is_action_just_pressed("bash") and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_ceiling():
		return State.BonkAir
	if timerDuration.is_stopped():
		return State.Fall
	if dashBufferState != State.Null:
		if dashBufferState == State.DashAir:
			if timerChain.is_stopped() and abilities.chain_check(PlayerAbilities.list.DashSide):
				abilities.consume(PlayerAbilities.list.DashChain, 1)
				return State.DashAir
			elif abilities.can_use(PlayerAbilities.list.DashSide):
				abilities.consume(PlayerAbilities.list.Dash, 1)
				return State.DashAir
		elif dashBufferState == State.DashUp:
			if timerChain.is_stopped() and abilities.chain_check(PlayerAbilities.list.DashUp):
				abilities.consume(PlayerAbilities.list.DashChain, 1)
				return State.DashUp
			elif abilities.can_use(PlayerAbilities.list.DashUp):
				abilities.consume(PlayerAbilities.list.Dash, 1)
				return State.DashUp
		elif dashBufferState == State.DashDown:
			if timerChain.is_stopped() and abilities.chain_check(PlayerAbilities.list.DashDown):
				abilities.consume(PlayerAbilities.list.DashChain, 1)
				return State.DashDown
			elif abilities.can_use(PlayerAbilities.list.DashDown):
				abilities.consume(PlayerAbilities.list.Dash, 1)
				return State.DashDown

	return State.Null


func timers() -> void:
	timerDuration.wait_time = duration
	timerDuration.start()
	timerChain.start()
