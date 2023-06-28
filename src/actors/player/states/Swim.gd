extends PlayerInfo


@export var velocityModifier: float = 1

var swimVelocity: float


func enter() -> void:
	swimVelocity = moveSpeed * velocityModifier
	player.animPlayer.queue("Swim")


func exit() -> void:
	player.animPlayer.stop()


func physics(delta) -> void:
	player.move_and_slide()
	
#	var velocity_target = player.moveDirection * swimVelocity
	if player.moveDirection == Vector2.ZERO:
		player.velocity.y = 100
		apply_friction(frictionGround * 2, delta)
#	elif abs(player.velocity) < abs(velocity_target): #TODO: need to find a better way for accel and deccel
#		player.velocity = player.velocity.move_toward(velocity_target, accelerationAir * delta)
	else:
		player.velocity = player.moveDirection * swimVelocity


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if Input.is_action_just_pressed("bash") and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.SwimDash):
		return State.SwimDash
 
	return State.Null


func state_check(delta: float) -> int:
	if !player.inWater:
		return State.Fall
	
	return State.Null
