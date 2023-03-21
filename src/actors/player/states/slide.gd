extends PlayerInfo

#TODO: get closer to Dread slide
#LOOKAT: sliding up hill

@export var duration: float = 0.3
@export var durationTimer: Timer
@export var particles: GPUParticles2D

var saveTriple: bool


func enter() -> void:
	player.animPlayer.queue("Slide")
	player.velocityPrevious = player.velocity
	saveTriple = true if abilities.currentJumpConsec > 1 else false
	durationTimer.wait_time = duration
	durationTimer.start()
	particles.emitting = true
	player.velocity.y = 0
	player.velocity.x = player.facing * (dashVelocity / duration) #TODO: change to check if current speed is higher


func exit() -> void:
	player.animPlayer.stop()
	particles.emitting = false


func physics(delta) -> void:
	player.move_and_slide_rotation()
	player.timers.consecutiveJump.start()
	
	if !player.is_on_floor():
		gravity_logic(gravityFall, delta)
		fall_speed_logic(terminalVelocity)


func visual(delta) -> void:
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump") and player.is_on_floor(): 
			return consecutive_jump_logic()
			
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall():
		return State.Idle #LOOKAT: could mess things up
	if durationTimer.is_stopped(): #TODO: upgrade that keeps sliding to
		if player.is_on_floor(): #TODO: if keeping make cd timer
			if player.crouch_ceiling_detect():
				player.velocity.x = 0
				return State.Crouch
			elif Input.is_action_pressed("crouch"):
				player.velocity.x = 0
				return State.Crouch
			elif player.moveDirection.x != 0:
				return State.Walk #lookat: interaction with speedboost
			else:
				return State.Idle
		else:
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
