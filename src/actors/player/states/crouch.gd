extends PlayerInfo

#TODO: add crawl state

@export var timerCoyoteJump: Timer
@export var timerCoyoteJumpGroundPound: Timer
@export var timerBufferJump: Timer
@export var timerBufferRoll: Timer
@export var timerConsecutiveJump: Timer
@export var detector: ShapeCast2D

@export var crouchSpeedMin: int = 20
@export var minLongJumpVelocity: int = 30

var saveConsecutive: bool = false

#LOOKAT: crouch stores consec jumps


func enter() -> void:
	player.animPlayer.queue("Crouch")
	
	neutral_move_direction_logic()
	
	if !timerConsecutiveJump.is_stopped():
		saveConsecutive = true


func exit() -> void:
	player.animPlayer.stop()
	
	if saveConsecutive:
		timerConsecutiveJump.start() #LOOKAT: fun challange of need high jump but don't have the room, so need to roll or slide
		saveConsecutive = false


func physics(delta) -> void:
	player.move_and_slide()
	
	apply_friction(stats.frictionGround * stats.crouchFriction, delta)


func visual(delta) -> void:
	player.facing_logic()
	align_to_ground()


func sound(delta: float) -> void:
	if player.velocity.x != 0:
		#TODO: need a sound when sliding
		pass


func handle_input(event: InputEvent) -> int:
	if !detector.is_colliding():
		if !input.pressedCrouch:
			if player.velocity.x != 0:
				return State.Walk
			else:
				return State.Idle
		if input.justPressedJump:
			if input.pressedDown:
				player.set_collision_mask_value(CollisionLayers.Semisolid, false)
#				if player.jumped: #FIXME: what is this???
#					consecutive_jump_cancel() #LOOKAT: maybe not cancel to carry triple jump
#					return State.JumpLong #TODO: special jump, timer to get a boosted jump
			else:
				if (abs(player.velocity.x) > minLongJumpVelocity or input.moveDirection.x != 0) and abilities.can_use(PlayerAbilities.list.JumpLong):
					return State.JumpLong
				elif !timerCoyoteJumpGroundPound.is_stopped() and abilities.can_use(PlayerAbilities.list.JumpGroundPound): ## gives extra time after ground pound to still get boosted jump
					return State.JumpGroundPound
				elif abilities.can_use(PlayerAbilities.list.JumpCrouch):
					#TODO: add time check, for charging jump
					return State.JumpCrouch
		if input.justPressedDash and abilities.can_use(PlayerAbilities.list.DashJump): #TODO: add charge time
			return State.DashJump
	if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Roll):
		return State.Roll
	if input.pressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
#TODO:
#	if ground.groundAngle > 1:
#		return State.Slide
	if !player.is_on_floor() and !ground.detectorGroundLeft.is_colliding() and !ground.detectorGroundRight.is_colliding():
		timerCoyoteJump.start()
		return State.Fall
	if !timerBufferJump.is_stopped() and abilities.can_use(PlayerAbilities.list.JumpCrouch):
		timerBufferJump.stop()
		EventBus.helperUsed.emit(Util.helper.coyoteJump)
		return State.JumpCrouch
	if !timerBufferRoll.is_stopped() and abilities.can_use(PlayerAbilities.list.Roll):
		timerBufferRoll.stop()
		return State.Roll

	return State.Null
