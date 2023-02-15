extends PlayerInfo

#FIXME: use wall direction to control particles
var duration: float = 0.3
@export var particles: GPUParticles2D


func enter() -> void:
	abilities.consume(PlayerAbilities.list.Dash, 1) #TODO: Change to energy
	player.velocityPrevious = player.velocity
	particles.emitting = true
	player.velocity.y = -dashVelocity / duration
	player.velocity.x = 0
	player.set_collision_layer_value(CollisionLayers.DashUp, true) #TODO: change to function
	player.set_collision_mask_value(CollisionLayers.DashUp, false)


func exit() -> void:
	particles.emitting = false 
	#TODO: add to other classes
	player.set_collision_layer_value(CollisionLayers.DashUp, false) #TODO: make function to turn off raycasts
	player.set_collision_mask_value(CollisionLayers.DashUp, true)

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
	if Input.is_action_just_pressed("crouch") and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
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
			return State.DashAir
		if abilities.can_use(PlayerAbilities.list.DashUp) and dashBufferState == State.DashUp:
			return State.DashUp
		if abilities.can_use(PlayerAbilities.list.DashDown) and dashBufferState == State.DashDown:
			return State.DashDown

	return State.Null
