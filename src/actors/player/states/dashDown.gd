extends PlayerInfo


@export var duration: float = 0.3
@export var durationTimer: Timer
@export var floorTime: float = 0.1


func enter() -> void:
	abilities.consume(PlayerAbilities.list.Dash, 1)  #TODO: Change to energy
	player.velocityPrevious = player.velocity
	durationTimer.wait_time = duration
	durationTimer.start()
	player.particles.dashDown.emitting = true #TODO: use signals to call
	player.velocity.x = 0
	player.velocity.y = dashVelocity / duration
	player.set_collision_layer_value(CollisionLayers.DashDown, true) #TODO: change to function
	player.set_collision_mask_value(CollisionLayers.DashDown, false)


func exit() -> void:
	player.particles.dashDown.emitting = false #TODO: use signals to call
	player.velocity.y = player.velocity.y/4
	player.set_collision_layer_value(CollisionLayers.DashDown, false)
	player.set_collision_mask_value(CollisionLayers.DashDown, true)


func physics(delta) -> void:
	player.move_and_slide()


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
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
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()

	return State.Null


func state_check(delta: float) -> int:
	var floorTimer: float
	floorTimer = floorTime
	if player.is_on_ceiling(): #TODO: bonk ceiling
		return State.Fall
	if player.is_on_floor():
		player.landed()
		floorTimer -= delta
		if floorTimer < 0 or durationTimer.is_stopped():
			return State.Idle
	if durationTimer.is_stopped():
		return State.Fall
	if dashBufferState != State.Null:
		if abilities.can_use(PlayerAbilities.list.DashSide) and dashBufferState == State.DashAir:
			return State.DashAir
		if abilities.can_use(PlayerAbilities.list.DashUp) and dashBufferState == State.DashUp:
			return State.DashUp

	return State.Null
