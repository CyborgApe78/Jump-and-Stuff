extends PlayerInfo
#TODO: sound

@export var groundPoundModifier: float = 2.0


func enter() -> void:
	player.velocity.y = max(moveSpeed * groundPoundModifier, abs(player.velocity.y))
	
#	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
#	tween.tween_property(player.characterRotate,"rotation_degrees", player.facing * 360, 0.2) ## flip,
#	tween.tween_property(player.characterCollision,"rotation_degrees", player.facing * 360, 0.2)


func exit() -> void:
	player.characterRotate.rotation_degrees = 0 
	player.characterCollision.rotation_degrees = 0 


func physics(delta) -> void:
	player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta) #TODO: make downward version
	
	player.move_and_slide()
	player.velocity.x = 0


func visual(delta) -> void:
	squash_and_stretch(delta)
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("glide")  and abilities.can_use_ability(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive")  and abilities.can_use_ability(PlayerAbilities.list.Dive):
		#TODO: special further dive
		return State.Dive
	if Input.is_action_just_pressed("dash") and abilities.can_use_ability(abilities.list.DashSide):
		return State.DashAir

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_floor():
		player.landed()
#		if !Input.is_action_pressed("ground pound"):
#			return State.GroundPoundBounce
#		else:
			#TODO: if groundpound pressed and 
		if player.moveDirection.x != 0:
			return State.BellySlide #TODO: change to back slide
		else:
			player.sounds.land.play()
			return State.Idle #TODO: groundpound land state, jump out of that

	return State.Null
