extends PlayerInfo

#TODO: shrink to crouch size

@export var duration: float = 0.3
@export var durationTimer: Timer

var saveTriple: bool


func enter() -> void:
	player.velocityPrevious = player.velocity
	saveTriple = true if abilities.currentJumpConsec > 1 else false
	durationTimer.wait_time = duration
	durationTimer.start()
	player.particles.dash.emitting = true #TODO: use signals to call
	player.velocity.y = 0
	player.velocity.x = player.facing * (dashVelocity / duration)
	player.set_collision_layer_value(CollisionLayers.DashSide, true) #TODO: change to function
	player.set_collision_mask_value(CollisionLayers.DashSide, false) #LOOKAT: different layer


func exit() -> void:
	player.particles.dash.emitting = false #TODO: use signals to call
	
	player.set_collision_layer_value(CollisionLayers.DashSide, false)
	player.set_collision_mask_value(CollisionLayers.DashSide, true)


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
			return State.DashAir
		if abilities.can_use(PlayerAbilities.list.DashUp) and dashBufferState == State.DashUp:
			return State.DashUp
		if abilities.can_use(PlayerAbilities.list.DashDown) and dashBufferState == State.DashDown:
			return State.DashDown

	return State.Null
