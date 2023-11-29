extends PlayerInfo


@export_group("Connections")
@export var soundSlide: AudioStreamPlayer
@export var particlesSlide: GPUParticles2D
@export var detector: ShapeCast2D

@export_group("")


func enter() -> void:
	soundSlide.play()
	player.animPlayer.queue("Belly Slide")


func exit() -> void:
	soundSlide.stop()
	player.animPlayer.stop()


func physics(delta) -> void:
	player.move_and_slide_rotation()
	
	if !player.is_on_floor():
		velocity.gravity_logic(stats.gravityFall, delta)
	
	if rad_to_deg(ground.groundAngle) < -1:
		if sign(player.velocity.x) == -1:
			player.velocity.x -= stats.downHillAccel ## Speed up on down hill
		else:
			velocity.apply_friction(stats.frictionGround * stats.upHillFrictionModifier, delta) ## Slow on up hill
	elif rad_to_deg(ground.groundAngle) > 1:
		if sign(player.velocity.x) == 1:
			player.velocity.x += stats.downHillAccel
		else:
			velocity.apply_friction(stats.frictionGround * stats.upHillFrictionModifier, delta)
	else:
		velocity.apply_friction(stats.frictionGround * 0.75, delta)


func visual(delta) -> void:
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if !detector.is_colliding():
		if input.justPressedJump and abilities.can_use(PlayerAbilities.list.JumpBelly):
			return State.BellySlideHop
	if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Roll):
		return State.Roll
	if input.justPressedDash and abilities.can_use(PlayerAbilities.list.DashBelly):
		return State.BellySlideDash
	if input.justPressedCrouch:
		return State.Crouch

	return State.Null


func state_check(delta: float) -> int:
	if player.velocity.x == 0:
		if detector.is_colliding():
			return State.Crouch
		else:
			if input.moveDirection.x != 0:
				if input.pressedCrouch:
					return State.CrouchWalk
				else:
					return State.Walk
			else:
				if input.pressedCrouch:
					return State.Crouch
				else:
					return State.Idle

	return State.Null
