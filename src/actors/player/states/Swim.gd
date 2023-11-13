extends PlayerInfo

#TODO: quick jump off the water
#TODO: jump out of water
#TODO: Swim Idle state
#TODO: accelleration
#TODO: when approaching water dive in
#TODO: swim faster button

@export_group("Connections")

@export_group("")



func enter() -> void:
	player.animPlayer.queue("Swim")
	abilities.reset(PlayerAbilities.list.All)


func exit() -> void:
	player.animPlayer.stop()


func physics(delta) -> void:
	player.move_and_slide()
	
#	var velocityTarget = input.swimDirection * swimVelocity
	
	if input.moveDirection == Vector2.ZERO:
		player.velocity.y = move_toward(player.velocity.y, 100, stats.frictionAir * 10 * delta)
		velocity.apply_friction(stats.frictionAir * 5, delta)
#		velocity.apply_friction(frictionGround * 2, delta)
	#TODO: acceleration
#	elif abs(player.velocity) < abs(velocityTarget): #TODO: need to find a better way for accel and deccel
#		player.velocity = player.velocity.move_toward(velocityTarget, stats.accelerationAir * delta)
	else:
		player.velocity = input.swimDirection * stats.moveSpeed * stats.swimVelocityModifier 


func visual(delta) -> void:
#	player.facing_logic(input.lastMoveDirection.x)
#FIXME: getting closer, ori fixes orientaion after going direction for a few seconds
	if input.swimDirection != Vector2.ZERO:
		player.characterRotate.rotation = lerp_angle(player.characterRotate.rotation, Vector2.UP.angle_to(player.velocity), delta * 10)
	else:
		if player.characterRotate.rotation != 0:
			player.characterRotate.rotation = lerp_angle(player.characterRotate.rotation, 0, delta * 5)


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justPressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim
#	if input.justPressedDash and abilities.can_use(PlayerAbilities.list.SwimDash):
#		return State.SwimDash
 
	return State.Null


func state_check(delta: float) -> int:
	if !player.inWater:
		return State.Fall
	
	return State.Null
