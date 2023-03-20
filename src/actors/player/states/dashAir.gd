extends PlayerInfo


var duration: float = 0.3
@export var durationTimer: Timer
@export var chainTimer: Timer #TODO: visual feedback when chain can be used
@export var jumpWallSaveTimer: Timer
@export var particles: GPUParticles2D #TODO: make rest of particles for states like this

#TODO: conserve consec jump, make challenge were 2 jump, dash under then triple jump


func enter() -> void:
	GameStats.dashSide += 1
	player.velocityPrevious = player.velocity
	timers()
	player.animPlayer.queue("Dash Side")
	particles.emitting = true 
	player.velocity.y = 0
	player.velocity.x = player.facing * (dashVelocity / duration)
	player.ability_mask(CollisionLayers.DashSide, false)


func exit() -> void:
	player.animPlayer.stop()
	particles.emitting = false
	if player.moveDirection.x != 0:
		player.velocity.x = player.velocityPrevious.x
	player.ability_mask(CollisionLayers.DashSide, true)

func physics(delta) -> void:
	player.move_and_slide()
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		jumpWallSaveTimer.start()
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
	if Input.is_action_just_pressed("crouch") and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
	if Input.is_action_just_pressed("dash"): #TODO: cd from normal dash, but can still chain them
		dash_pressed_buffer()

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall(): 
		if !jumpWallSaveTimer.is_stopped():
			return State.JumpWall #TODO: create JumpReflect
		elif topSpeed > moveSpeed:
			topSpeed = 0
			return State.BonkAir
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
	if durationTimer.is_stopped():
		if player.is_on_floor():
			player.landed()
			return State.Walk
		else:
			return State.Fall

	return State.Null


func timers() -> void:
	durationTimer.wait_time = duration
	durationTimer.start()
	chainTimer.start()
