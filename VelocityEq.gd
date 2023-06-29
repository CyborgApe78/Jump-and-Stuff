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
#			player.velocity.x = player.moveDirection.x * max(abs(speed), abs(player.velocity.x))
#	if !useMoveDirection:
#		if abs(player.velocity.x) < moveSpeed:
#			player.velocity.x = player.velocity.x
#		else:
#			player.velocity.x =  max(abs(speed), abs(player.velocity.x)) * player.facing
#
#
#func air_velocity_logic(speed: float, acceleration: float, friction: float, delta: float) -> void:
#	
#	if movedirection != 0 and abs(player.velocity.x) > moveSpeed:
#	#	player.velocity.x = moveSpeed * sign(player.velocity.x)
#	if player.velocity.x != 0  and player.moveDirection.x != 0 and (sign(player.velocity.x) != player.moveDirection.x):
#		player.velocity.x = player.lastMoveDirection.x * 1
##		player.velocity.x = move_toward(player.velocity.x / airTurnModifier, speed * player.moveDirection.x, acceleration)
#		add min(player.velocity.x / airTurnModifier, maxTurnSpeed) to velocity to keep from scaling to large
#	else:
#		if player.velocity.x != 0 and sign(player.velocity.x) != player.lastMoveDirection.x:
#			player.velocity.x = player.lastMoveDirection.x * 1
#		elif player.moveDirection.x != 0 and abs(player.velocity.x) < speed:
#			apply_acceleration(speed, acceleration, delta)
#		elif player.moveDirection.x == 0:
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
#func squash_and_stretch(delta):
##	if !player.is_on_floor():
##		player.characterRig.scale.y = remap(abs(player.velocity.y), 0, abs(jumpVelocity), 0.75, 1.25)
##		player.characterRig.scale.x = remap(abs(player.velocity.y), 0, abs(jumpVelocity), 1.25, 0.75)
##
##	player.characterRig.scale.x = lerp(player.characterRig.scale.x, 1.0, 1.0 - pow(0.01, delta))
##	player.characterRig.scale.y = lerp(player.characterRig.scale.y, 1.0, 1.0 - pow(0.01, delta))
#	pass
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
#	if player.groundAngle != 0:
#		player.rotation = player.groundAngle
#
#
#func neutral_move_direction_logic() -> void:
#	if player.moveDirection == Vector2.ZERO:
#		player.neutralMoveDirection = true
#	else:
#		player.neutralMoveDirection = false
#
#
#func neutral_air_momentum_logic(speed) -> void:
#	if player.moveDirection.x != 0 and player.neutralMoveDirection: ## Cancel out neutral momentum
#		player.neutralMoveDirection = false
