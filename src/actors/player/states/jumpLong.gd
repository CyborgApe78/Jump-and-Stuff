extends PlayerInfo

#TODO: if coming from double create special jump
#TODO: bounce of enemy changes to another long jump
#TODO: spin combo, ref https://www.mariowiki.com/Double_kick

@export var jumpModifier: float = 0.9
@export var velocityModifier: float = 1.35


func enter() -> void:
	EventBus.emit_signal("actionAnnounce", "Boing")
	topSpeed = 0
	neutral_move_direction_logic()
	player.sounds.jump.pitch_scale = jumpModifier
	player.sounds.jump.play()
	player.particles.jumpTriple.restart()
	player.velocity.y = jumpVelocity * jumpModifier
	player.velocity.x = moveSpeed * velocityModifier * player.facing


func exit() -> void:
	player.sounds.jump.pitch_scale = 1


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	gravity_logic(gravityJump, delta)
	
	if player.neutralMoveDirection:
		neutral_air_momentum_logic(moveSpeed)
	else:
		air_velocity_logic(moveSpeed, accelerationAir, frictionAir, delta)
	#TODO add control lockout or deminished air turn
	player.move_and_slide_rotation()
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("glide")  and abilities.can_use_ability(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive")  and abilities.can_use_ability(PlayerAbilities.list.Dive):
		return State.Dive
	if Input.is_action_just_pressed("dash") and abilities.can_use_ability(abilities.list.DashSide):
		return State.DashAir
#	if !Input.is_action_pressed("crouch"):
		#TODO: change velocity based on whether crouch is held
#	if Input.is_action_just_pressed("ground pound"):
#		return State.GroundPound
	#TODO: long jump into roll. if crouch is pressed and roll is just pressed

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall() and topSpeed > moveSpeed:
		topSpeed = 0
		return State.BonkAir
#	if player.velocity.y > -jumpApexHeight:
#		return State.JumpApex #TODO: change to fall state if over certian velocity or time 
	if player.is_on_floor():
		player.landed()
		if player.velocity.x != 0:
			return State.Walk
		else:
			return State.Idle
	if player.is_on_ceiling():
		return State.Fall

	return State.Null
