extends PlayerInfo
#TODO: sound

@export var transTime: float = 0.1
@export var particles: GPUParticles2D


func enter() -> void:
	player.velocity.y = max(moveSpeed, abs(player.velocity.y))
	player.animPlayer.queue("Ground Pound") #TODO: use signals to send to animationtree
	if player.characterRotate.rotation_degrees != 0:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(player.characterRotate, "rotation_degrees", 0, transTime).from(0)
		tween.tween_property(player.characterCollision, "rotation_degrees", 0, transTime).from(0)


func exit() -> void:
	player.characterRotate.rotation_degrees = 0 
	player.characterCollision.rotation_degrees = 0 


func physics(delta) -> void:
	player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta) #TODO: make downward version
	gravity_logic(gravityFall, delta)
	player.move_and_slide()
	player.velocity.x = 0


func visual(delta) -> void:
	squash_and_stretch(delta)
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		if !player.timers.coyoteJump.is_stopped(): #leave ground, but stil can jump
			player.timers.coyoteJump.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			return consecutive_jump_logic()
		elif abilities.can_use(PlayerAbilities.list.JumpAir) and !(player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding()): #TODO: ground check to use buffer instead of double jump
			return State.JumpAir
		else:
			player.timers.bufferJump.start()
	if Input.is_action_just_pressed("glide")  and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive")  and abilities.can_use(PlayerAbilities.list.Dive):
		#TODO: special further dive
		return State.Dive
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()

	return State.Null


func state_check(delta: float) -> int:
	if !player.is_on_floor():
		player.GPBounce = player.velocity
	if player.is_on_floor(): #TODO: lock player for impact
		particles.restart()
		abilities.reset(PlayerAbilities.list.JumpAir)
		abilities.reset(PlayerAbilities.list.Dash)
		abilities.reset(PlayerAbilities.list.DashChain)
		player.sounds.land.play()
		if Input.is_action_pressed("ground pound") and abilities.can_use(PlayerAbilities.list.GroundPoundBounce): #TODO: change to jump 
			return State.GroundPoundBounce
		elif player.moveDirection.x != 0:
			return State.Slide 
		else:
			return State.Idle #TODO: groundpound land state, jump out of that
	if dashBufferState != State.Null:
		if abilities.can_use(PlayerAbilities.list.DashSide) and dashBufferState == State.DashAir: #TODO: groundDash
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashAir
		if abilities.can_use(PlayerAbilities.list.DashUp) and dashBufferState == State.DashUp:
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashUp
		if abilities.can_use(PlayerAbilities.list.DashDown) and dashBufferState == State.DashDown:
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashDown

	return State.Null
