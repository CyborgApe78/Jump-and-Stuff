extends PlayerInfo

#TODO: change shape to 1x2

@export var duration: float = 0.3
@export var durationTimer: Timer
@export var particles: GPUParticles2D

var saveTriple: bool


func enter() -> void:
	player.animPlayer.play("Slide Enter")
	player.velocityPrevious = player.velocity
	saveTriple = true if abilities.currentJumpConsec > 1 else false
	durationTimer.wait_time = duration
	durationTimer.start()
	particles.emitting = true
	player.velocity.y = 0
	player.velocity.x = player.facing * (dashVelocity / duration)
	player.ability_mask(CollisionLayers.DashSide, false)


func exit() -> void:
	player.animPlayer.play("Slide Exit")
	particles.emitting = false
	player.ability_mask(CollisionLayers.DashSide, true)


func physics(delta) -> void:
	player.move_and_slide_rotation()
	player.timers.consecutiveJump.start()


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
			if Input.is_action_pressed("crouch"):
				player.velocity.x = 0
				return State.Crouch
			else:
				return State.Idle #TODO: or crouch if in small area
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
