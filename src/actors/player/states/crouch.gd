extends PlayerInfo

@export var crouchSpeedMin: int = 20
@export var minLongJumpVelocity: int = 30
@export var transformTime: float = 0.2

var crouchReleased: bool = false

#LOOKAT: crouch stores consec jumps
#TOSO: change control to down pressed

func enter() -> void:
	crouchReleased = false
	neutral_move_direction_logic()
	player.animPlayer.queue("Crouch")


func exit() -> void:
	player.animPlayer.stop()


func physics(delta) -> void:
	player.move_and_slide()
#	if !player.neutralMoveDirection: #TODO: skates upgrade, no ground friction
	apply_friction(frictionGround * 1.5, delta)


func visual(delta) -> void:
	player.facing_logic()
	align_to_ground()


func sound(delta: float) -> void:
	if player.velocity.x != 0:
		#TODO: need a sound when sliding
		pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_released("crouch"):
		if player.crouch_ceiling_detect():
			crouchReleased = true
		else:
			if player.velocity.x != 0:
				return State.Walk
			else:
				return State.Idle
	if Input.is_action_just_pressed("jump") and !player.crouch_ceiling_detect():
		if player.jumped:
			consecutive_jump_cancel() #LOOKAT: maybe not cancel to carry triple jump
			return State.JumpLong #TODO: special jump, timer to get a boosted jump
		elif abs(player.velocity.x) > minLongJumpVelocity:
			return State.JumpLong
		else:
			return State.JumpCrouch
	if Input.is_action_just_pressed("spin") and abilities.can_use(PlayerAbilities.list.Slide):
		return State.Slide
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashJump) and !player.crouch_ceiling_detect():
		return State.DashJump ## shinespark
	#TODO:
#		if Input.is_action_just_pressed("dive"):
#			return State.Roll
	if Input.is_action_just_pressed("crouch"):
		crouchReleased = false
	if Input.is_action_just_pressed("slide"): #TODO change to roll 
		return State.Slide 
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook

	return State.Null


func state_check(delta: float) -> int:
#TODO:
#	if player.groundAngle > 1:
#		return State.BackSlide
	if crouchReleased and !player.crouch_ceiling_detect():
		if player.velocity.x != 0:
			return State.Walk
		else:
			return State.Idle
	if !player.is_on_floor() and !player.detectorGroundLeft.is_colliding() and !player.detectorGroundRight: #TODO: better ground check for all states
		player.timers.coyoteJump.start()
		return State.Fall
	if !player.timers.bufferJump.is_stopped():
		player.timers.bufferJump.stop()
		EventBus.helperUsed.emit(Util.helper.coyoteJump)
		return State.JumpCrouch

	return State.Null
