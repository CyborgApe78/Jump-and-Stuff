extends Resource
class_name VelEq
## Velocity Equations

#TODOL convert all player states to this

static func gravity_logic(amount: float, delta: float) -> float:
	var gravity = amount * delta
	
	return gravity


func fall_speed_logic(current: float, amount: float) -> float:
	var fall_speed = min(current, amount)
	
	return fall_speed


static func apply_acceleration(current: float, speed: float, amount: float, direction: float, delta: float, useDirection: bool = true) -> float:
	
	var accel: float
	
	if useDirection:
		accel = move_toward(abs(current), speed, amount * delta) * direction
	else:
		accel = move_toward(abs(current), speed, amount * delta)

	return accel


static func apply_friction(current: float, amount: float, delta: float) -> float:
	var friction = move_toward(current, 0, amount * delta)

	return friction


#func momentum_logic(speed: float, useMoveDirection: bool) -> float:
#	if useMoveDirection:
#		if abs(player.velocity.x) < moveSpeed:
#			player.velocity.x = player.velocity.x
#		else:
#			player.velocity.x = input.moveDirection.x * max(abs(speed), abs(player.velocity.x))
#	if !useMoveDirection:
#		if abs(player.velocity.x) < moveSpeed:
#			player.velocity.x = player.velocity.x
#		else:
#			player.velocity.x = max(abs(speed), abs(player.velocity.x)) * player.facing
#
#
#func air_velocity_logic(speed: float, acceleration: float, friction: float, delta: float) -> void:
#	
#	if movedirection != 0 and abs(player.velocity.x) > moveSpeed:
#	#	player.velocity.x = moveSpeed * sign(player.velocity.x)
#	if player.velocity.x != 0 and input.moveDirection.x != 0 and (sign(player.velocity.x) != input.moveDirection.x):
#		player.velocity.x = input.lastMoveDirection.x * 1
##		player.velocity.x = move_toward(player.velocity.x / airTurnModifier, speed * input.moveDirection.x, acceleration)
#		add min(player.velocity.x / airTurnModifier, maxTurnSpeed) to velocity to keep from scaling to large
#	else:
#		if player.velocity.x != 0 and sign(player.velocity.x) != input.lastMoveDirection.x:
#			player.velocity.x = input.lastMoveDirection.x * 1
#		elif input.moveDirection.x != 0 and abs(player.velocity.x) < speed:
#			apply_acceleration(speed, acceleration, delta)
#		elif input.moveDirection.x == 0:
#			apply_friction(friction, delta)
#		elif abs(player.velocity.x) >= speed:
#			momentum_logic(speed, true)
#
#
#
#
#func speed_bend(forwardLean: bool = true, speed = moveSpeed, leanAmount: float = 0.1) -> void:
#	if forwardLean:
#		player.characterRig.skew = remap(player.velocity.x, 0, speed, 0.0, leanAmount)
#	if !forwardLean:
#		player.characterRig.skew = remap(-player.velocity.x, 0, speed, 0.0, leanAmount)
#
#
#func consecutive_jump_logic() -> int:
#	if abilities.can_use(PlayerAbilities.list.JumpConsec) and player.jumped:
#		return State.JumpConsec
#	else:
#		return State.Jump
#
#
#func align_to_ground()-> void:
#	if ground.groundAngle != 0:
#		player.rotation = ground.groundAngle
#
#
#func neutral_move_direction_logic() -> void:
#	if input.moveDirection == Vector2.ZERO:
#		input.neutralMoveDirection = true
#	else:
#		input.neutralMoveDirection = false
#
#
#func neutral_air_momentum_logic(speed) -> void:
#	if input.moveDirection.x != 0 and input.neutralMoveDirection: ## Cancel out neutral momentum
#		input.neutralMoveDirection = false
