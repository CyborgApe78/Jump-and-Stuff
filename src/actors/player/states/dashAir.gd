extends PlayerInfo

#TODO: upgrade for ori like burrow

@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var timerLongJump: Timer ## Currrently not used, was going to be long distance if jump timing hit
@export var timerDuration: Timer
@export var timerChain: Timer
@export var timerBufferJumpWall: Timer
@export var particles: GPUParticles2D
@export var soundJetpack: AudioStreamPlayer
@export var detector: ShapeCast2D

var duration: float = 0.4


func enter() -> void:
	soundJetpack.play()
	EventBus.playerDashed.emit()
	player.velocityPrevious = player.velocity
	timers()
	player.animPlayer.queue("Dash Side Air")
	particles.local_coords = true
	particles.emitting = true 
	player.velocity.y = 0
	if player.is_on_wall():
		player.velocity.x = -player.wallDirection * dashVelocity
	else:
		player.velocity.x = player.facing * dashVelocity
	player.ability_mask(CollisionLayers.DashSide, false)


func exit() -> void:
	soundJetpack.stop()
	player.animPlayer.stop()
	particles.local_coords = false
	particles.emitting = false
	if player.moveDirection.x != 0:
		player.velocity.x = player.velocityPrevious.x
		## If no input keep dash velocity
	player.ability_mask(CollisionLayers.DashSide, true)
	timerChain.stop()
	timerDuration.stop()


func physics(delta) -> void:
	player.move_and_slide()
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		timerBufferJumpWall.start()
		if !timerCoyoteJump.is_stopped(): #leave ground, but stil can jump
			timerCoyoteJump.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			return consecutive_jump_logic()
		elif abilities.can_use(PlayerAbilities.list.JumpAir) and !(player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding()):
			player.velocity.x = 0
			return State.JumpAir
		else:
			timerBufferJump.start()
			player.velocity.x = 0
			return State.Fall #LOOKAT: removing canceling out of dash
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
	if player.is_on_wall(): 
		if !timerBufferJumpWall.is_stopped():
			return State.JumpWall #TODO: create JumpReflect
		elif topSpeed > moveSpeed:
			topSpeed = 0
			return State.BonkAir
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
	if timerDuration.is_stopped():
		if detector.is_colliding():
			player.velocity.x = player.velocity.x
			return State.BellySlide
		else:
			if Input.is_action_pressed("glide") and abilities.can_use(PlayerAbilities.list.Glide):
				return State.Glide
			elif player.is_on_floor():
				player.velocity.x = player.velocity.x/4
				player.landed()
				return State.Walk
			else:  ## Neutral input leaves the player with the most speed on exiting
				if player.moveDirection.x == 0:
					player.velocity.x = player.velocity.x/2
				else:
					if player.moveDirection.x == player.facing:
						player.velocity.x = moveSpeed
					else:
						player.velocity.x = 0
				return State.Fall

	return State.Null


func timers() -> void:
	timerDuration.wait_time = duration
	timerDuration.start()
	timerChain.wait_time = duration * 0.8
	if abilities.chain_check(PlayerAbilities.list.DashChain):
		timerChain.start()
	timerLongJump.wait_time = duration * 0.8
