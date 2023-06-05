extends PlayerInfo

#TODO: add block break indicator
#FIXME: use wall direction to control particles

var duration: float = 0.3
@export var particles: GPUParticles2D
@export var soundJetpack: AudioStreamPlayer


func enter() -> void:
	GameStats.dashSide += 1 #TODO: own stat
	EventBus.playerDashed.emit()
	soundJetpack.play()
	player.velocityPrevious = player.velocity
	particles.local_coords = true
	particles.emitting = true
	player.velocity.y = -dashVelocity
	player.velocity.x = 0
	player.ability_mask(CollisionLayers.DashUp, false)


func exit() -> void:
	soundJetpack.stop()
	particles.local_coords = false
	particles.emitting = false 
	player.ability_mask(CollisionLayers.DashUp, true)

func physics(delta) -> void:
	player.move_and_slide()


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		if abilities.can_use(PlayerAbilities.list.JumpAir): #TODO: ground check to use buffer instead of double jump
			return State.JumpAir
		else:
			player.timers.bufferJump.start()
			return State.Fall
	if Input.is_action_just_pressed("glide")  and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
#	if Input.is_action_just_pressed("dive")  and abilities.can_use(PlayerAbilities.list.Dive):
#		return State.Dive TODO: maybe keep but need to go away from wall
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()

	return State.Null


func state_check(delta: float) -> int:
	if !player.is_on_wall():
		return State.Fall
	if player.is_on_ceiling():
		return State.WallSlide
	if dashBufferState != State.Null:
		if abilities.can_use(PlayerAbilities.list.DashSide) and dashBufferState == State.DashAir:
			abilities.consume(PlayerAbilities.list.DashSide, 1)
			return State.DashAir
		if abilities.can_use(PlayerAbilities.list.DashUp) and dashBufferState == State.DashUp:
			abilities.consume(PlayerAbilities.list.DashUp, 1)
			return State.DashUp
		if abilities.can_use(PlayerAbilities.list.DashDown) and dashBufferState == State.DashDown:
			abilities.consume(PlayerAbilities.list.DashDown, 1)
			return State.DashDown

	return State.Null
