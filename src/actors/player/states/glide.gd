extends PlayerInfo

#TODO: animation turned on side, think buzz lightyear mixed with mario cape
#TODO: add a check to double jump and others to go back to glide if it is still held

@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var timerConsecutiveJump: Timer

@export var transTime: float = 0.1
@export var velocityModifier: float = 0.6
@export var velocityFallModifier: float = 0.3


func enter() -> void:
	player.velocityPrevious = player.velocity
	neutral_move_direction_logic()
	player.animPlayer.play("Glide")
	player.set_up_direction(Vector2.UP)
	if player.characterRotate.rotation_degrees != 0:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(player.characterRotate, "rotation_degrees", 0, transTime).from(0)
		tween.tween_property(player.characterCollision, "rotation_degrees", 0, transTime).from(0)


func exit() -> void:
	player.animPlayer.stop()


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	
	if player.neutralMoveDirection:
		neutral_air_momentum_logic(moveSpeed * velocityModifier)
	else:
		air_velocity_logic(moveSpeed * velocityModifier, accelerationAir, frictionAir, delta)
	
	if player.inWind:
		player.velocity.y = player.windVelocity.y
	else:
		gravity_logic(gravityFall * velocityFallModifier, delta)
		fall_speed_logic(terminalVelocity * velocityFallModifier)
	
	track_top_speed(player.velocity.x)
	
	


func visual(delta) -> void:
	squash_and_stretch(delta)
	align_to_ground()
	player.facing_logic()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_released("glide"):
		return State.Fall
	if Input.is_action_just_pressed("jump"):
		if !timerCoyoteJump.is_stopped(): #leave ground, but stil can jump
			timerCoyoteJump.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			return consecutive_jump_logic()
		elif abilities.can_use(PlayerAbilities.list.JumpAir) and !(player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding()):
			return State.JumpAir
		else:
			timerBufferJump.start()
			return State.Fall
	if Input.is_action_just_pressed("dive"):
		return State.Dive
	if Input.is_action_just_pressed("ground_pound") and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashSide):
		abilities.consume(PlayerAbilities.list.DashSide, 1)
		return State.DashAir
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if Input.is_action_just_pressed("bash") and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall() and topSpeed > moveSpeed:
		topSpeed = 0
		return State.BonkAir
	if player.is_on_floor():
		player.landed()
		timerConsecutiveJump.start()
		if Input.is_action_pressed("crouch"):
			return State.Crouch
		elif player.velocity.x != 0: 
			return State.Walk
		else:
			return State.Idle

	return State.Null
