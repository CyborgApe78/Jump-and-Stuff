extends PlayerInfo
#TODO: sound

@export var groundPoundModifier: float = 2.0
@export var transTime: float = 0.1


func enter() -> void:
	player.velocity.y = max(moveSpeed * groundPoundModifier, abs(player.velocity.y))
	
	if player.characterRotate.rotation_degrees != 0:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(player.characterRotate, "rotation_degrees", 0, transTime).from(0)
		tween.tween_property(player.characterCollision, "rotation_degrees", 0, transTime).from(0)


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
	if Input.is_action_just_pressed("glide")  and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive")  and abilities.can_use(PlayerAbilities.list.Dive):
		#TODO: special further dive
		return State.Dive
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()

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
	if dashBufferState != State.Null:
		if abilities.can_use(PlayerAbilities.list.DashSide) and dashBufferState == State.DashAir:
			dashBufferState = State.Null
			return State.DashAir
		if abilities.can_use(PlayerAbilities.list.DashUp) and dashBufferState == State.DashUp:
			dashBufferState = State.Null
			return State.DashUp

	return State.Null
