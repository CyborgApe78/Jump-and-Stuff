extends PlayerInfo

@export var timerCoyoteJump: Timer
@export var timerConsecutiveJump: Timer
@export var soundeffect: AudioStreamPlayer

#TODO: if moveDirection.x != 0, spin jump, metroid like
#TODO: look into combine jump and jumpConsec

func enter() -> void:
	EventBus.playerJumped.emit()
	topSpeed = 0
	neutral_move_direction_logic()
	player.animPlayer.queue("Jump")
	soundeffect.play()
	player.velocity.y = jumpVelocity
	timers()
	player.jumped = true


func exit() -> void:
	player.animPlayer.stop()


func physics(delta) -> void:
	
	player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide_rotation()
	
	gravity_logic(gravityJump, delta)
	
	if player.neutralMoveDirection:
		neutral_air_momentum_logic(moveSpeed)
	else:
		air_velocity_logic(moveSpeed, accelerationAir, frictionAir, delta)
	
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	squash_and_stretch(delta)
	player.facing_logic()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_released("jump"):
		player.velocity.y = max( player.velocity.y, jumpVelocity * percentMinJumpVelocity)
		if player.velocity.y > jumpVelocity * percentKeepJumpConsecutive: ## needs to be a percent of full jump to keep it going
			consecutive_jump_cancel()
		return State.Fall
	if Input.is_action_just_pressed("glide")  and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive")  and abilities.can_use(PlayerAbilities.list.Dive):
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
	if player.is_on_ceiling():
		consecutive_jump_cancel()
		return State.Fall
	if player.is_on_wall():
		if topSpeed > moveSpeed:
			topSpeed = 0
			return State.BonkAir
		else:
			return State.WallLand
	if player.velocity.y > -jumpApexHeight:
		return State.JumpApex
	if player.is_on_floor():
		player.landed()
		if player.velocity.x != 0:
			return State.Walk
		else:
			return State.Idle

	return State.Null


func timers () -> void:
	timerCoyoteJump.stop()
	timerConsecutiveJump.stop()
