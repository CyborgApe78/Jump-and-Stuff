extends PlayerInfo
#TODO: air crouch
#TODO: holding down makes you go through semisolids

@export var timerCoyoteJump: Timer
@export var timerCoyoteJumpWall: Timer
@export var timerBufferJump: Timer
@export var timerBufferRoll: Timer
@export var timerFall: Timer
@export var timerConsecutiveJump: Timer
@export var timerSemisolidReset: Timer

@export var jumpHeldSlowModifier: float = 2.0
@export var transTime: float = 0.1
@export var fallTimeTillBonk: float = 0.9
var jumpHeld: bool


func enter() -> void:
	player.velocityPrevious = player.velocity
	timers()
	topSpeed = 0
	neutral_move_direction_logic()
	player.animPlayer.queue("Fall")
	player.set_up_direction(Vector2.UP)
	if player.characterRotate.rotation_degrees != 0:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(player.characterRotate, "rotation_degrees", 0, transTime).from(0)
		tween.tween_property(player.characterCollision, "rotation_degrees", 0, transTime).from(0)
	player.velocity = player.velocity.rotated(0)


func exit() -> void:
	player.animPlayer.stop() #FIXME: kills land animation
	jumpHeld = false


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	
	if timerCoyoteJump.is_stopped():
		gravity_logic(gravityFall, delta)
	
	if jumpHeld:
		fall_speed_logic(terminalVelocity / jumpHeldSlowModifier)
	elif player.moveDirection.y == 1:
		fall_speed_logic(terminalVelocity * 1.5)
	else:
		fall_speed_logic(terminalVelocity)
	
	track_top_speed(player.velocity.x)
	
	if player.neutralMoveDirection:
		neutral_air_momentum_logic(moveSpeed)
	else:
		air_velocity_logic(moveSpeed, accelerationAir, frictionAir, delta)


func visual(delta) -> void:
	squash_and_stretch(delta)
	align_to_ground()
	player.facing_logic()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_pressed("move_down"):
		player.set_collision_mask_value(CollisionLayers.Semisolid, false)
		timerSemisolidReset.stop()
	if Input.is_action_just_released("move_down"):
		timerSemisolidReset.start()
	if Input.is_action_pressed("jump"):
		jumpHeld = true
	else: 
		jumpHeld = false
	if Input.is_action_just_pressed("jump"):
		timerBufferJump.start()
		if !timerCoyoteJump.is_stopped(): #leave ground, but stil can jump
			timerCoyoteJump.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			EventBus.playerActionAnnounce.emit("Coyote Jump")
			return consecutive_jump_logic()
		elif !timerCoyoteJumpWall.is_stopped() and abilities.can_use(PlayerAbilities.list.JumpWall): #leave wall, but stil can jump
			timerCoyoteJumpWall.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			EventBus.playerActionAnnounce.emit("Wall Coyote Jump")
			return State.JumpWall
		elif player.wall_detection(10) != 0 and abilities.can_use(PlayerAbilities.list.JumpWall):
			EventBus.playerActionAnnounce.emit("Near Wall Jump")
			return State.JumpWall
		elif abilities.can_use(PlayerAbilities.list.JumpAir) and !(player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding()):
			return State.JumpAir
		else:
			timerBufferJump.start()
	if Input.is_action_pressed("glide") and abilities.can_use(PlayerAbilities.list.Glide): #FIXME: need to find a way to check 
		return State.Glide
	if Input.is_action_just_pressed("dive") and abilities.can_use(PlayerAbilities.list.Dive):
		return State.Dive
	if Input.is_action_just_pressed("ground_pound") and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if Input.is_action_just_pressed("bash") and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim
	

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall():
		if !timerBufferJump.is_stopped() and abilities.can_use(PlayerAbilities.list.JumpWall):
			return State.JumpWall
		if topSpeed > moveSpeed:
			topSpeed = 0
			return State.BonkAir
		else:
			return State.WallSlide
	if player.is_on_floor():
		player.landed()
		if !timerBufferJump.is_stopped():
			timerBufferJump.stop()
			EventBus.helperUsed.emit(Util.helper.bufferJump)
			EventBus.rumble.emit(0.1, 0.3, 0.2)
			return consecutive_jump_logic()
		if !timerBufferRoll.is_stopped() and abilities.can_use(PlayerAbilities.list.Roll):
			timerBufferRoll.stop()
			EventBus.rumble.emit(0.1, 0.3, 0.2)
			return State.Roll
		elif timerFall.is_stopped():
			return State.BonkGround
		else:
			timerConsecutiveJump.start()
			if Input.is_action_pressed("crouch"):
				player.animPlayer.stop()
				EventBus.rumble.emit(0.1, 0.2, 0.2)
				return State.Crouch
			elif player.velocity.x != 0:
	#			if player.neutralMoveDirection:
	#				return State.NeutralGround #TODO: keep momentum if jumping
	#			else:
				EventBus.rumble.emit(0.1, 0.2, 0.2)
				return State.Walk
			else:
				EventBus.rumble.emit(0.1, 0.2, 0.2)
				return State.Idle
	if dashBufferState != State.Null:
		if dashBufferState == State.DashAir and abilities.can_use(PlayerAbilities.list.DashSide):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashAir
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashUp
		if dashBufferState == State.DashDown and abilities.can_use(PlayerAbilities.list.DashDown):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashDown

	return State.Null


func timers() -> void:
	timerFall.wait_time = fallTimeTillBonk
	timerFall.start()
