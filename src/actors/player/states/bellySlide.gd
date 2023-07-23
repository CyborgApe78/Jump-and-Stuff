extends PlayerInfo


@export var timerDiveJump: Timer
@export var soundSlide: AudioStreamPlayer
@export var detector: ShapeCast2D

@export var diveJumpTime: float = 0.2


func enter() -> void:
	soundSlide.play()
	timerDiveJump.wait_time = diveJumpTime
	timerDiveJump.start()
	player.animPlayer.queue("Belly Slide")


func exit() -> void:
	soundSlide.stop()
	player.animPlayer.stop()


func physics(delta) -> void:
	player.move_and_slide_rotation()
	
	if !player.is_on_floor():
		gravity_logic(gravityFall, delta)
	
	if rad_to_deg(player.groundAngle) < -1:
		if sign(player.velocity.x) == -1:
			player.velocity.x -= downHillAccel ## Speed up on down hill
		else:
			apply_friction(frictionGround * upHillFrictionModifier, delta) ## Slow on up hill
	if rad_to_deg(player.groundAngle) > 1:
		if sign(player.velocity.x) == 1:
			player.velocity.x += downHillAccel #TODO: make like friction func, need a top speed or make this function
		else:
			apply_friction(frictionGround * upHillFrictionModifier, delta)
	else:
		apply_friction(frictionGround * 1.5, delta)


func visual(delta) -> void:
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	#TODO: add check for returning to two block height
	#TODO: add entering other states
	if !detector.is_colliding():
		if Input.is_action_just_pressed("jump"):
			if !timerDiveJump.is_stopped(): # timer to get a special jump
				return State.JumpLong 
	#			return State.BellyHop #TODO: special jump
			else:
				player.velocity.x = 0
				return State.Jump
	if Input.is_action_just_pressed("roll"):
#	 and abilities.can_use(PlayerAbilities.list.Roll): #TODO: turn into unlock
		return State.Roll

	return State.Null


func state_check(delta: float) -> int:
	if player.velocity.x == 0:
		if detector.is_colliding():
			return State.Crouch
		else:
			if player.moveDirection.x != 0:
				return State.Walk
			else:
				return State.Idle

	return State.Null
