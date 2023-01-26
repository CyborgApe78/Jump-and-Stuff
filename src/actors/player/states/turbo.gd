extends PlayerInfo


var gravity = 100


func enter() -> void:
	player.animPlayer.play("walk")
	player.particlesWalking.emitting = true


func exit() -> void:
	player.particlesWalking.emitting = false


func physics(delta) -> void:
	if player.moveDirection.x != 0:
		if abs(player.velocity.x) < moveSpeed:
			player.velocity.x = move_toward(abs(player.velocity.x), moveSpeed, stats.accelerationGround) * player.moveDirection.x
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, stats.frictionGround)
	player.velocity.y += gravity * delta
	player.move_and_slide_rotation()
	


func visual(delta) -> void:
	speed_bend(false)
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_pressed("crouch"): 
		return State.Crouch
	if Input.is_action_just_pressed("jump"):
		return consecutive_jump_logic()

	return State.Null


func state_check(delta: float) -> int:
	if !player.is_on_floor():
		player.timers.coyoteJump.start()
		return State.Fall
	if abs(player.velocity.x) < moveSpeed:
		return State.Walk
	if player.velocity.x == 0:
		return State.Idle
	if !player.timers.bufferJump.is_stopped():
		player.timers.bufferJump.stop()
		EventBus.helperUsed.emit(Util.helper.bufferJump)
		return consecutive_jump_logic()

	return State.Null

