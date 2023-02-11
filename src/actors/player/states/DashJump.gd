extends PlayerInfo

#INGGAME: Rocket Jump
#TODO: needs to be charged from PSpeed
@export var duration: float = 0.3
@export var durationTimer: Timer


func enter() -> void:
	abilities.consume(PlayerAbilities.list.Dash, 1) #TODO: Change to energy
	player.velocityPrevious = player.velocity
	timers()
	player.particles.dashUp.emitting = true #TODO: use signals to call
	player.velocity = player.aimDirection * (dashVelocity * 1.6 / duration)
	player.set_collision_layer_value(CollisionLayers.DashUp, true) #TODO: change to function
	player.set_collision_mask_value(CollisionLayers.DashUp, false)


func exit() -> void:
	player.particles.dashUp.emitting = false #TODO: use signals to call
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
	if Input.is_action_just_pressed("dive")  and abilities.can_use(PlayerAbilities.list.Dive):
		return State.Dive
	if Input.is_action_just_pressed("crouch") and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_ceiling(): #TODO: bonk ceiling
		return State.Fall
	if durationTimer.is_stopped():
		return State.Fall
	if dashBufferState != State.Null:
		if abilities.can_use(PlayerAbilities.list.DashSide) and dashBufferState == State.DashAir:
			dashBufferState = State.Null
			return State.DashAir
		if abilities.can_use(PlayerAbilities.list.DashUp) and dashBufferState == State.DashUp:
			dashBufferState = State.Null
			return State.DashUp
		if abilities.can_use(PlayerAbilities.list.DashDown) and dashBufferState == State.DashDown:
			dashBufferState = State.Null
			return State.DashDown

	return State.Null


func timers() -> void:
	durationTimer.wait_time = duration
	durationTimer.start()
