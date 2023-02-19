extends PlayerInfo
#INGGAME: Rocket Jump, Shinespark inspired
#TODO: remove duration
#TODO: needs to be charged from SpeedBoost, 
#TODO: delay for aiming
@export var duration: float = 0.3
@export var durationTimer: Timer
@export var particles: GPUParticles2D


func enter() -> void:
	player.velocityPrevious = player.velocity
	timers()
	particles.emitting = true
	player.velocity = player.aimDirection * (dashVelocity * 1.6 / duration) #TODO: find a more forgiving way to get 8 directions
	player.ability_layer(CollisionLayers.DashJump, true)


func exit() -> void:
	particles.emitting = false
	player.ability_layer(CollisionLayers.DashJump, false)


func physics(delta) -> void:
	player.move_and_slide()


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	#TODO: less states to go into
	if Input.is_action_just_pressed("jump"):
		if abilities.can_use(PlayerAbilities.list.JumpAir): #TODO: ground check to use buffer instead of double jump
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
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()
#	if Input.is_action_just_pressed("grapple hook"): #TODO
#		return State.GrappleHook

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_ceiling() or player.is_on_wall(): #TODO: autograb walls? or make player save from bonk
		return State.Fall
	if durationTimer.is_stopped():
		return State.Fall
	if dashBufferState != State.Null:
		if abilities.can_use(PlayerAbilities.list.DashSide) and dashBufferState == State.DashAir:
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashAir
		if abilities.can_use(PlayerAbilities.list.DashUp) and dashBufferState == State.DashUp:
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashUp
		if abilities.can_use(PlayerAbilities.list.DashDown) and dashBufferState == State.DashDown:
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashDown

	return State.Null


func timers() -> void:
	durationTimer.wait_time = duration
	durationTimer.start()
