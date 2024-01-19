extends PlayerInfo


@export_group("Connections")
@export var timerCoyoteJump: Timer
@export var timerCoyoteJumpGroundPound: Timer ## gives extra time after ground pound to still get boosted jump
@export var timerBufferJump: Timer
@export var timerConsecutiveJump: Timer
@export var timerCharge: Timer
@export var soundeffect: AudioStreamPlayer
@export var detector: ShapeCast2D

var saveConsecutive: bool = false


func enter() -> void:
	player.animPlayer.queue("Crouch Walk")
	
	timerCharge.wait_time = stats.timeCrouchCharge
	timerCharge.start() #Todo: don't restart when coming from crouch
	
	if !timerConsecutiveJump.is_stopped():
		saveConsecutive = true


func exit() -> void:
	player.animPlayer.stop()
	soundeffect.stop()
	player.animPlayer.speed_scale = 1
	
	timerCharge.stop() #TODO: don't stop if going to crouch
	
	if saveConsecutive:
		timerConsecutiveJump.start() #LOOKAT: fun challange of need high jump but don't have the room, so need to roll or slide
		saveConsecutive = false


func physics(delta) -> void:
	player.move_and_slide()
	
	if player.velocity.x != 0 and sign(player.velocity.x) != input.lastMoveDirection.x: ## kill velocity when changing directions
		player.velocity.x = input.lastMoveDirection.x * 1
	elif input.moveDirection.x != 0 and abs(player.velocity.x) < stats.moveSpeed * stats.crouchVelocityModifier: #LOOKAT: moving these to stats
		velocity.apply_acceleration(stats.moveSpeed * stats.crouchVelocityModifier, stats.accelerationGround, delta)
	elif input.moveDirection.x == 0:
		velocity.apply_friction(stats.frictionGround, delta)


func visual(delta) -> void:
	player.animation_speed(.004)
	player.facing_logic(input.moveDirection.x)
	align_to_ground()
	


func sound(delta: float) -> void:
		pass


func handle_input(event: InputEvent) -> int:
	if !detector.is_colliding():
		if !input.pressedCrouch:
			if player.velocity.x != 0:
				return State.Walk
			else:
				return State.Idle
		if input.justPressedDash and abilities.can_use(PlayerAbilities.list.DashJump) and timerCharge.is_stopped():
			return State.DashJump
		if input.justPressedJump:
#			if abs(player.velocity.x) > stats.minLongJumpVelocity and abilities.can_use(PlayerAbilities.list.JumpLong):
#				return State.JumpLong
			if !timerCoyoteJumpGroundPound.is_stopped() and abilities.can_use(PlayerAbilities.list.JumpGroundPound):
				return State.JumpGroundPound
			elif timerCharge.is_stopped() and abilities.can_use(PlayerAbilities.list.JumpCrouchCharged):
				return State.JumpCrouchCharged
			elif abilities.can_use(PlayerAbilities.list.JumpCrouch):
				return State.JumpCrouch
	if input.justPressedJump:
		if input.pressedDown:
			player.set_collision_mask_value(CollisionLayers.Semisolid, false)
		elif abilities.can_use(PlayerAbilities.list.JumpCrouch):
			return State.JumpCrouch
	if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Roll):
		return State.Roll
	if input.pressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if player.velocity.x == 0:
		return State.Crouch
	if !player.is_on_floor() and !ground.detectorGroundLeft.is_colliding() and !ground.detectorGroundRight.is_colliding():
		timerCoyoteJump.start()
		return State.Fall
	if !timerBufferJump.is_stopped() and abilities.can_use(PlayerAbilities.list.JumpCrouch):
		timerBufferJump.stop()
		EventBus.helperUsed.emit(Util.helper.coyoteJump)
		return State.JumpCrouch
	if !detector.is_colliding() and !input.pressedCrouch: ##TODO: move to input
		return State.Walk

	return State.Null

