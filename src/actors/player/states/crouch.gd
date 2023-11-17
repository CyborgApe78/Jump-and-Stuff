extends PlayerInfo


@export_group("Connections")
@export var timerCoyoteJump: Timer
@export var timerCoyoteJumpGroundPound: Timer ## gives extra time after ground pound to still get boosted jump
@export var timerBufferJump: Timer
@export var timerBufferRoll: Timer
@export var timerConsecutiveJump: Timer
@export var timerCharge: Timer
@export var detector: ShapeCast2D
@export var particlesCharge: GPUParticles2D
@export var particlesSlide: GPUParticles2D
@export var soundSlide: AudioStreamPlayer

@export_group("")
@export var timeCharge: int = 1 #TODO: move to timers

var saveConsecutive: bool = false

#LOOKAT: crouch stores consec jumps


func enter() -> void:
	player.animPlayer.queue("Crouch")
	#TODO: Squash and stretch player up from crouch
	
	timerCharge.wait_time = timeCharge
	timerCharge.start() #Todo: don't restart when coming from crouch walk
	
	input.neutral_move_direction_logic()
	
	if !timerConsecutiveJump.is_stopped():
		saveConsecutive = true


func exit() -> void:
	player.animPlayer.stop()
	timerCharge.stop() #TODO: don't stop if going to crouch walk
	soundSlide.stop()
	
	if saveConsecutive:
		timerConsecutiveJump.start() #LOOKAT: fun challange of need high jump but don't have the room, so need to roll or slide
		saveConsecutive = false


func physics(delta) -> void:
	player.move_and_slide()
	
	velocity.apply_friction(stats.frictionCrouch, delta)


func visual(delta) -> void:
	player.facing_logic(input.moveDirection.x)
	align_to_ground()
	
	if player.velocity.x != 0:
		particlesSlide.restart()


func sound(delta: float) -> void:
	if player.velocity.x != 0 and !soundSlide.playing:
		soundSlide.play()
	elif player.velocity.x == 0 and soundSlide.playing:
		soundSlide.stop()


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
			if abs(player.velocity.x) > stats.minLongJumpVelocity and (sign(player.velocity.x) == input.moveDirection.x or input.moveDirection.x == 0) and abilities.can_use(PlayerAbilities.list.JumpLong):
				return State.JumpLong
			elif !timerCoyoteJumpGroundPound.is_stopped() and abilities.can_use(PlayerAbilities.list.JumpGroundPound):
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
	if abs(player.velocity.x) < stats.minLongJumpVelocity:
		if input.moveDirection.x != 0:
			return State.CrouchWalk

	return State.Null


func state_check(delta: float) -> int:
	if ground.groundAngle != 0: 
		return State.SlideButt
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


func _on_charge_timeout() -> void:
	particlesCharge.restart()
