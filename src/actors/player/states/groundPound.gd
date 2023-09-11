extends PlayerInfo

#TODO: add states converting down dash to side
#TODO: drill upgrade from spin

@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var timerSemisolidReset: Timer
@export var detector: ShapeCast2D

@export var transTime: float = 0.1


func enter() -> void:
	if !detector.is_colliding(): #TODO: only move up if in semisolid
		player.global_position.y -= Util.tileSize * 4 #TODO: smooth movement
	player.velocity.y = max(stats.moveSpeed, abs(player.velocity.y))
	player.animPlayer.queue("Ground Pound")
	if player.characterRotate.rotation_degrees != 0:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(player.characterRotate, "rotation_degrees", 0, transTime).from(0)
		tween.tween_property(player.characterCollision, "rotation_degrees", 0, transTime).from(0)


func exit() -> void:
	player.characterRotate.rotation_degrees = 0 
	player.characterCollision.rotation_degrees = 0 


func physics(delta) -> void:
	player.attempt_vertical_corner_correction(stats.jumpCornerCorrectionVertical, delta) #TODO: make downward version
	player.move_and_slide()
	
	gravity_logic(stats.gravityFall, delta)
	
	player.velocity.x = 0
#	if Input.is_action_pressed("ground_pound"): ## could use this bounce along the ground
#		player.velocity.x = 0
#	else:
#		air_velocity_logic(moveSpeed, accelerationAir, frictionAir, delta)


func visual(delta) -> void:
	squash_and_stretch(delta)
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_pressed("move_down"):
		player.set_collision_mask_value(CollisionLayers.Semisolid, false)
		timerSemisolidReset.stop()
	if Input.is_action_just_released("move_down"):
		timerSemisolidReset.start()
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
	if Input.is_action_just_pressed("glide") and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive") and abilities.can_use(PlayerAbilities.list.Dive):
		return State.DiveHop
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if Input.is_action_just_pressed("bash") and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if !player.is_on_floor():
		player.GPMaxVelocity = player.velocity
	if player.is_on_floor():
		if !Input.is_action_pressed("ground_pound") and abilities.can_use(PlayerAbilities.list.GroundPoundBounce):
			player.landed()
			return State.GroundPoundBounce
		else:
			return State.GroundPoundLand
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
