extends PlayerInfo

#TODO: if coming from double create special jump
#TODO: bounce of enemy changes to another long jump
#TODO: spin combo, ref https://www.mariowiki.com/Double_kick

@export var jumpModifier: float = 0.9
@export var velocityModifier: float = 1.35
@export var particles: GPUParticles2D


func enter() -> void:
	GameStats.jumps += 1
	EventBus.playerJumped.emit()
	topSpeed = 0
	neutral_move_direction_logic()
	player.animPlayer.queue("Jump")
	player.sounds.jump.pitch_scale = jumpModifier
	player.sounds.jump.play()
	particles.restart()
	player.velocity.y = jumpVelocity * jumpModifier
	player.velocity.x = max(moveSpeed * velocityModifier, abs(player.velocity.x)) * player.facing

func exit() -> void:
	player.animPlayer.stop()
	player.sounds.jump.pitch_scale = 1


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	
	gravity_logic(gravityJump, delta)
	
	if player.neutralMoveDirection:
		neutral_air_momentum_logic(moveSpeed)
	else:
		air_velocity_logic(moveSpeed, accelerationAir, frictionAir, delta)
	#TODO add control lockout or deminished air turn
	
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
#		if player.wall_detection(15) != 0:
#			return State.JumpWall
		if abilities.can_use(PlayerAbilities.list.JumpAir) and !(player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding()): #TODO: ground check to use buffer instead of double jump
			return State.JumpAir
		else:
			player.timers.bufferJump.start()
	if Input.is_action_just_pressed("glide")  and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive")  and abilities.can_use(PlayerAbilities.list.Dive):
		return State.Dive
#	if Input.is_action_just_pressed("ground_pound") and abilities.can_use(PlayerAbilities.list.GroundPound): 
#		return State.GroundPound ## turned off so long jump chaining is easier
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashSide):
		abilities.consume(PlayerAbilities.list.DashSide, 1)
		return State.DashAir
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
#	if !Input.is_action_pressed("crouch"):
		#TODO: change velocity based on whether crouch is held
	#TODO: long jump into roll. if crouch is pressed and roll is just pressed

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall():
		if !player.timers.bufferJump.is_stopped():
			return State.JumpWall #TODO: add to other states
		elif topSpeed > moveSpeed:
			topSpeed = 0
			return State.BonkAir
		elif player.velocity.y < 0: ## player is going up go to wallland else slide
			return State.WallLand
		else:
			return State.WallSlide
#	if player.velocity.y > -jumpApexHeight:
#		return State.JumpApex #FixMe: change to fall state if over certian velocity or time 
	if player.is_on_floor():
		player.landed()
		if !player.timers.bufferJump.is_stopped():
			if Input.is_action_pressed("crouch"):
				return State.JumpLong
			else: 
				return State.Jump
		if player.velocity.x != 0:
			return State.Walk
		else:
			return State.Idle
	if player.is_on_ceiling():
		return State.Fall

	return State.Null
