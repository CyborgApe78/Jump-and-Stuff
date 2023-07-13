extends PlayerInfo


@export var timerBufferJump: Timer
@export var timerBufferRoll: Timer
@export var soundeffect: AudioStreamPlayer
@export var particles: GPUParticles2D

@export var jumpModifier: float = 0.9
@export var velocityModifier: float = 1.35
@export var rollTime: float = 0.3

var startingHeight: int
var velocityLongJump: float


func enter() -> void:
	timers()
	EventBus.playerJumped.emit()
	startingHeight = player.global_position.y
	topSpeed = 0
	neutral_move_direction_logic()
	player.animPlayer.queue("Jump")
	soundeffect.pitch_scale = jumpModifier
	soundeffect.play()
	particles.restart()
	player.velocity.y = jumpVelocity * jumpModifier
	velocityLongJump = moveSpeed * velocityModifier
#	player.velocity.x = max(moveSpeed * velocityModifier, abs(player.velocity.x)) * player.facing


func exit() -> void:
	player.animPlayer.stop()
	soundeffect.pitch_scale = 1


func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	
	gravity_logic(gravityJump, delta)
	
	if player.neutralMoveDirection:
		neutral_move_direction_logic()
		if abs(player.velocity.x) < velocityLongJump:
			player.velocity.x = move_toward(abs(player.velocity.x), velocityLongJump, (moveSpeed * 3) * delta) * player.facing
	else:
		if player.moveDirection.x != 0:
			if player.moveDirection.x != player.facing:
#				player.velocity.x = move_toward(player.velocity.x, 0, (moveSpeed * 2) * delta)
				apply_friction(moveSpeed * 2, delta)
			elif player.moveDirection.x == player.facing and abs(player.velocity.x) < velocityLongJump:
#					apply_acceleration(velocityLongJump, moveSpeed * 3, delta) #TODO: make func to input direction
					player.velocity.x = move_toward(abs(player.velocity.x), velocityLongJump, (moveSpeed * 3) * delta) * player.facing
	
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
#		if player.wall_detection(15) != 0:
#			return State.JumpWall
		if abilities.can_use(PlayerAbilities.list.JumpAir) and !(player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding()):
			return State.JumpAir
		else:
			timerBufferJump.start()
	if Input.is_action_just_pressed("glide")  and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
#	if Input.is_action_just_pressed("dive")  and abilities.can_use(PlayerAbilities.list.Dive):
#		return State.Dive ## not needed since it changes to fall state automagically
#	if Input.is_action_just_pressed("ground_pound") and abilities.can_use(PlayerAbilities.list.GroundPound): 
#		return State.GroundPound ## turned off so long jump chaining is easier
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashSide):
		abilities.consume(PlayerAbilities.list.DashSide, 1)
		return State.DashAir
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if Input.is_action_just_pressed("bash") and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim
#	if !Input.is_action_pressed("crouch"):
		#TODO: change velocity based on whether crouch is held
	if Input.is_action_pressed("crouch") and Input.is_action_just_pressed("roll"):
		timerBufferRoll.start()

	return State.Null


func state_check(delta: float) -> int:
	if player.global_position.y > startingHeight: ## leave state when passing starting height
		return State.Fall
	if player.is_on_wall():
		if !timerBufferJump.is_stopped():
			return State.JumpWall
		elif topSpeed > moveSpeed:
			topSpeed = 0
			return State.BonkAir
		elif player.velocity.y < 0: ## player is going up go to wallland else slide
			return State.WallSlide
		else:
			return State.WallSlide
	if player.is_on_floor():
		player.landed()
		if Input.is_action_pressed("crouch"):
			if !timerBufferJump.is_stopped():
				return State.JumpLong
			elif !timerBufferRoll.is_stopped():
				return State.Roll
			else:
				return State.Crouch
		elif !timerBufferJump.is_stopped():
				return State.Jump
		elif player.velocity.x != 0:
			if player.moveDirection.x != sign(player.velocity.x) and player.moveDirection.x != 0:
				return State.Skid
			else:
				return State.Walk
		else:
			return State.Idle
	if player.is_on_ceiling():
		return State.Fall

	return State.Null

func timers() -> void:
	pass
