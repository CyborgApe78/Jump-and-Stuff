extends PlayerInfo

@export var crouchSpeedMin: int = 20
@export var frictionCrouch: float = 0.1 * Util.tileSize
@export var minLongJumpVelocity: int = 30
@export var transformTime: float = 0.2

#LOOKAT: crouch stores consec jumps

func enter() -> void:
	neutral_move_direction_logic()
	player.characterCollision.shape.height = 24
	player.characterCollision.shape.radius = 16
	player.characterCollision.position.y = -12
	player.animPlayer.play("crouchEnter")


func exit() -> void:
	player.characterCollision.shape.height = 48
	player.characterCollision.shape.radius = 16
	player.characterCollision.position.y = -24
	player.animPlayer.play("crouchExit")


func physics(delta) -> void:
	player.move_and_slide()
	if !player.neutralMoveDirection: #TODO: skates upgrade, no ground friction
		apply_friction(frictionCrouch, delta)


func visual(delta) -> void:
	align_to_ground()


func sound(delta: float) -> void:
	if player.velocity.x != 0:
		#TODO: need a sound when sliding
		pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_released("crouch"):
		if player.velocity.x != 0:
			return State.Walk
		else:
			return State.Idle
	if Input.is_action_just_pressed("jump"):
		if player.jumped:
			consecutive_jump_cancel() #LOOKAT: maybe not cancel to carry triple jump
			return State.JumpLong #TODO: special jump, timer to get a boosted jump
		elif abs(player.velocity.x) > minLongJumpVelocity:
			return State.JumpLong
		else:
			return State.JumpCrouch
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashJump):
		return State.DashJump ## shinespark
	#TODO:
#		if Input.is_action_just_pressed("dive"):
#			return State.Roll

	return State.Null


func state_check(delta: float) -> int:
#TODO:
#	if player.groundAngle > 1:
#		return State.BackSlide
	if !player.is_on_floor():
		player.timers.coyoteJump.start()
		return State.Fall
	if !player.timers.bufferJump.is_stopped():
		player.timers.bufferJump.stop()
		EventBus.helperUsed.emit(Util.helper.coyoteJump)
		return State.JumpCrouch

	return State.Null
