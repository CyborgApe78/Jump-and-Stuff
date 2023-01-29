extends PlayerInfo


func enter() -> void:
	player.velocityPrevious = player.velocity
	player.velocity.y = 0
	player.particles.wallSlide.emitting = true #TODO: use signals to call


func exit() -> void:
	player.particles.wallSlide.emitting = false #TODO: use signals to call


func physics(delta) -> void:
	player.move_and_slide()
	
	if player.moveDirection.y == Vector2.DOWN.y:
		gravity_logic(gravityFall, delta)
		fall_speed_logic(terminalVelocity)
	else:
		gravity_logic(gravityFall/4, delta)
		fall_speed_logic(terminalVelocity/4)


func visual(delta) -> void:
	pass 
	#TODO: need to move facing func to each state


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("move_left") and player.lastWallDirection == Vector2.RIGHT.x:
		player.velocity = Vector2(-20,-10)
		player.timers.coyoteJumpWall.start()
		return State.Fall
	if Input.is_action_just_pressed("move_right") and player.lastWallDirection == Vector2.LEFT.x:
		player.velocity = Vector2(20, -10)
		player.timers.coyoteJumpWall.start()
		return State.Fall

	return State.Null


func state_check(delta: float) -> int:
	if !player.is_on_wall():
		player.timers.coyoteJumpWall.start()
		return State.Fall
	if player.is_on_floor():
		player.landed()
		player.sounds.land.play() #Lookat: moving sound to landed
		if Input.is_action_pressed("crouch"):
			return State.Crouch
		elif player.velocity.x != 0: 
			return State.Walk
		else:
			return State.Idle

	return State.Null
