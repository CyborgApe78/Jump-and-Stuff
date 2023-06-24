extends PlayerInfo

#TODO: add dash down upgrade
#TODO: add states converting down dash to side

@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer

@export var transTime: float = 0.1
@export var particles: GPUParticles2D


func enter() -> void:
	player.velocity.y = max(moveSpeed, abs(player.velocity.y))
	player.animPlayer.queue("Ground Pound")
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
		if !timerCoyoteJump.is_stopped(): #leave ground, but stil can jump
			timerCoyoteJump.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			return consecutive_jump_logic()
		elif abilities.can_use(PlayerAbilities.list.JumpAir) and !(player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding()):
			return State.JumpAir
		else:
			timerBufferJump.start()
			return State.Fall
	if Input.is_action_just_pressed("glide")  and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive")  and abilities.can_use(PlayerAbilities.list.Dive):
		#TODO: special further dive
		return State.Dive
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashSide):
		abilities.consume(PlayerAbilities.list.DashSide, 1)
		if player.is_on_floor():
			return State.DashGround
		else:
			return State.DashAir
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if Input.is_action_just_pressed("bash") and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if !player.is_on_floor():
		player.GPMaxVelocity = player.velocity
	if player.is_on_floor():
		if !Input.is_action_pressed("ground_pound"):
			player.landed()
			return State.GroundPoundBounce
		else:
			return State.GroundPoundLand

	return State.Null
