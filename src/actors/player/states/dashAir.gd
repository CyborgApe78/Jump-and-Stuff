extends PlayerInfo


var duration: float = 0.3
@export var durationTimer: Timer
@export var chainTimer: Timer #TODO: visual feedback when chain can be used
@export var jumpWallSaveTimer: Timer
@export var particles: GPUParticles2D #TODO: make rest of particles for states like this

#TODO: conserve consec jump, make challenge were 2 jump, dash under then triple jump


func enter() -> void:
	abilities.consume(PlayerAbilities.list.Dash, 1) #TODO: move to state calling the change
	player.velocityPrevious = player.velocity
	timers()
	particles.emitting = true 
	player.velocity.y = 0
	player.velocity.x = player.facing * (dashVelocity / duration)
	player.set_collision_layer_value(CollisionLayers.DashSide, true) #TODO: change to function
	player.set_collision_mask_value(CollisionLayers.DashSide, false)


func exit() -> void:
	particles.emitting = false
	
#		player.consume_ability(PlayerAbilities.list.DashAir, 1)  #TODO
	if player.moveDirection.x != 0:
		player.velocity.x = player.velocityPrevious.x
	#TODO: add to other classes
	player.set_collision_layer_value(CollisionLayers.DashSide, false) #TODO: make function to turn off raycasts
	player.set_collision_mask_value(CollisionLayers.DashSide, true)

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
	if durationTimer.is_stopped():
		if player.is_on_floor():
			player.landed()
			return State.Walk
		else:
			return State.Fall
	if dashBufferState != State.Null:
		if dashBufferState == State.DashAir:
			if chainTimer.is_stopped() and abilities.chain_check(PlayerAbilities.list.DashSide):
				#TODO: currentChain +1
				return State.DashAir
			elif abilities.can_use(PlayerAbilities.list.DashSide):
				#TODO: abilities.consume(PlayerAbilities.list.Dash, 1)
				return State.DashAir
		if dashBufferState == State.DashUp:
			if chainTimer.is_stopped() and abilities.chain_check(PlayerAbilities.list.DashUp):
				return State.DashUp
			elif abilities.can_use(PlayerAbilities.list.DashUp):
				return State.DashUp
		if dashBufferState == State.DashDown:
			if chainTimer.is_stopped() and abilities.chain_check(PlayerAbilities.list.DashDown):
				abilities.remainingChain
				return State.DashDown
			elif abilities.can_use(PlayerAbilities.list.DashDown):
				return State.DashDown

	return State.Null


func timers() -> void:
	durationTimer.wait_time = duration
	durationTimer.start()
	chainTimer.start()
	
