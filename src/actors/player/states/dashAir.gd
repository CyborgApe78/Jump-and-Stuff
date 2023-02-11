extends PlayerInfo


#TODO: upgrade to become like bullet from mario
var duration: float = 0.3
@export var durationTimer: Timer
@export var distance: float = 4.0
@onready var dashSpeed: float = moveSpeed / duration #TODO: based off movespeed
@export var jumpWallSaveTimer: Timer

#TODO: conserve consec jump, make challenge were 2 jump, dash under then triple jump


func enter() -> void:
	abilities.consume(PlayerAbilities.list.Dash, 1) #TODO: Change to energy
	player.velocityPrevious = player.velocity
	timers()
	player.particles.dash.emitting = true #TODO: use signals to call
	player.velocity.y = 0
	player.velocity.x = player.facing * (dashVelocity / duration)
	player.set_collision_layer_value(CollisionLayers.DashSide, true) #TODO: change to function
	player.set_collision_mask_value(CollisionLayers.DashSide, false)


func exit() -> void:
	player.particles.dash.emitting = false #TODO: use signals to call
	
#		player.consume_ability(PlayerAbilities.list.DashAir, 1)  #TODO
	if player.moveDirection.x != 0:
		player.velocity.x = player.velocityPrevious.x
	#TODO: add to other classes
	player.set_collision_layer_value(CollisionLayers.DashSide, false) #TODO: make function to turn off raycasts
	player.set_collision_mask_value(CollisionLayers.DashSide, true)

func physics(delta) -> void:
	player.move_and_slide()
	player.timers.consecutiveJump.start()
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
#			return State.Fall
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
	if durationTimer.is_stopped():
		if player.is_on_floor():
			player.landed()
			return State.Walk
		else:
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
