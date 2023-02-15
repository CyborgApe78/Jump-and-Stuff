extends PlayerInfo


var duration: float = 0.3
@export var jumpWallSaveTimer: Timer
var dashDirection: int
@export var particles: GPUParticles2D


func enter() -> void:
	dashDirection = -player.wall_detection(30)
	abilities.consume(PlayerAbilities.list.Dash, 1) #TODO: Change to energy
	player.velocityPrevious = player.velocity
	particles.emitting = true
	player.velocity.y = 0
	player.velocity.x = dashDirection * (dashVelocity / duration)
	player.set_collision_layer_value(CollisionLayers.DashSide, true) #TODO: change to function
	player.set_collision_mask_value(CollisionLayers.DashSide, false)


func exit() -> void:
	particles.emitting = false 
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
		if abilities.can_use(PlayerAbilities.list.JumpAir) and !(player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding()): #TODO: ground check to use buffer instead of double jump
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
	if player.is_on_wall(): 
		if !jumpWallSaveTimer.is_stopped():
			return State.JumpWall #TODO: create JumpReflect
		elif topSpeed > moveSpeed:
			topSpeed = 0
			return State.BonkAir
	if dashBufferState != State.Null:
		if abilities.can_use(PlayerAbilities.list.DashSide) and dashBufferState == State.DashAir:
			return State.DashAir
		if abilities.can_use(PlayerAbilities.list.DashUp) and dashBufferState == State.DashUp:
			return State.DashUp
		if abilities.can_use(PlayerAbilities.list.DashDown) and dashBufferState == State.DashDown:
			return State.DashDown

	return State.Null
