extends PlayerInfo

#TODO: quick jump off the water
#TODO: jump out of water
#TODO: Swim Idle state
#TODO: accelleration

@export var velocityModifier: float = 1

var swimVelocity: float


func enter() -> void:
	swimVelocity = stats.moveSpeed * velocityModifier
	player.animPlayer.queue("Swim")
	abilities.reset(PlayerAbilities.list.All)


func exit() -> void:
	player.animPlayer.stop()


func physics(delta) -> void:
	player.move_and_slide()
	
	var velocity_target = input.swimDirection * swimVelocity
	
	if input.moveDirection == Vector2.ZERO:
		player.velocity.y = move_toward(player.velocity.y, 100, stats.frictionAir * 10 * delta)
		player.velocity.x = VelEq.apply_friction(player.velocity.x, stats.frictionAir* 5, delta)
#		player.velocity.x = VelEq.apply_friction(player.velocity.y, frictionGround * 2, delta)
#	elif abs(player.velocity) < abs(velocity_target): #TODO: need to find a better way for accel and deccel
#		player.velocity = player.velocity.move_toward(velocity_target, stats.accelerationAir * delta)
	else:
		player.velocity = input.swimDirection * swimVelocity #TODO: acceleration


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
