extends PlayerInfo

#INGGAME: Rocket Jump, Shinespark inspired
#TODO: remove duration
#TODO: needs to be charged from SpeedBoost, 
#TODO: delay for aiming
#TODO: add block break indicator

@export var duration: float = 0.3
@export var durationTimer: Timer
@export var particles: GPUParticles2D
@export var soundJetpack: AudioStreamPlayer


func enter() -> void:
	soundJetpack.play()
	GameStats.dashSide += 1 #TODO: own stat
	EventBus.playerDashed.emit()
	player.velocityPrevious = player.velocity
	timers()
	particles.local_coords = true
	particles.emitting = true
	player.velocity = player.aimDirection * dashVelocity * 1.6  #TODO: find a more forgiving way to get 8 directions
	player.ability_mask(CollisionLayers.DashJump, false)


func exit() -> void:
	soundJetpack.stop()
	particles.local_coords = false
	particles.emitting = false
	player.ability_mask(CollisionLayers.DashJump, true)


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
	if Input.is_action_just_pressed("ground_pound") and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashSide):
		abilities.consume(PlayerAbilities.list.DashSide, 1)
		return State.DashAir
#	if Input.is_action_just_pressed("grapple hook"): #TODO
#		return State.GrappleHook

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_ceiling() or player.is_on_wall(): #TODO: autograb walls? or make player save from bonk
		return State.Fall
	if durationTimer.is_stopped():
		return State.Fall

	return State.Null


func timers() -> void:
	durationTimer.wait_time = duration
	durationTimer.start()
