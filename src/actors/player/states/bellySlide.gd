extends PlayerInfo


@export var soundSlide: AudioStreamPlayer
@export var particlesSlide: GPUParticles2D #TODO: create particles
@export var detector: ShapeCast2D


func enter() -> void:
	soundSlide.play()
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
	elif rad_to_deg(player.groundAngle) > 1:
		if sign(player.velocity.x) == 1:
			player.velocity.x += downHillAccel #TODO: make like friction func, need a top speed or make this function
		else:
			apply_friction(frictionGround * upHillFrictionModifier, delta)
	else:
		apply_friction(frictionGround * 0.75, delta)


func visual(delta) -> void:
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	#TODO: add entering other states
	if !detector.is_colliding(): #FIXME: don't want to stop the hop if detecting, if removed player is stuck in wall
		if Input.is_action_just_pressed("jump") and abilities.can_use(PlayerAbilities.list.JumpBelly):
			return State.BellySlideHop
	if Input.is_action_just_pressed("roll") and abilities.can_use(PlayerAbilities.list.Roll):
		return State.Roll
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashBelly):
		return State.BellySlideDash

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
