extends PlayerInfo


@export var timerCoyoteJump: Timer
@export var timerCoyoteJumpGroundPound: Timer
@export var timerBufferJump: Timer
@export var timerBufferRoll: Timer
@export var detector: ShapeCast2D

@export var crouchSpeedMin: int = 20
@export var minLongJumpVelocity: int = 30
@export var transformTime: float = 0.2


#LOOKAT: crouch stores consec jumps


func enter() -> void:
	player.animPlayer.queue("Crouch")
	
	neutral_move_direction_logic()


func exit() -> void:
	player.animPlayer.stop()


func physics(delta) -> void:
	player.move_and_slide()
	
	apply_friction(frictionGround * 1.5, delta)


func visual(delta) -> void:
	player.facing_logic()
	align_to_ground()


func sound(delta: float) -> void:
	if player.velocity.x != 0:
		#TODO: need a sound when sliding
		pass


func handle_input(event: InputEvent) -> int:
	if !detector.is_colliding():
		if Input.is_action_just_released("crouch"):
			if player.velocity.x != 0:
				return State.Walk
			else:
				return State.Idle
		if Input.is_action_just_pressed("jump"):
			if Input.is_action_pressed("move_down"):
				player.set_collision_mask_value(CollisionLayers.Semisolid, false)
#				if player.jumped: #FIXME: what is this???
#					consecutive_jump_cancel() #LOOKAT: maybe not cancel to carry triple jump
#					return State.JumpLong #TODO: special jump, timer to get a boosted jump
			else:
				if abs(player.velocity.x) > minLongJumpVelocity or player.moveDirection.x != 0:
					return State.JumpLong
				elif !timerCoyoteJumpGroundPound.is_stopped(): ## gives extra time after ground pound to still get boosted jump
					return State.JumpGroundPound
				else:
					#TODO: add time check, for charging jump
					return State.JumpCrouch
		if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashJump): #TODO: add charge time
			return State.DashJump
	if Input.is_action_just_pressed("roll"):
		return State.Roll
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if Input.is_action_just_pressed("bash") and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
#TODO:
#	if player.groundAngle > 1:
#		return State.Slide
	if !player.is_on_floor() and !player.detectorGroundLeft.is_colliding() and !player.detectorGroundRight.is_colliding():
		timerCoyoteJump.start()
		return State.Fall
	if !timerBufferJump.is_stopped():
		timerBufferJump.stop()
		EventBus.helperUsed.emit(Util.helper.coyoteJump)
		return State.JumpCrouch
	if !timerBufferRoll.is_stopped():
		timerBufferRoll.stop()
		return State.Roll

	return State.Null
