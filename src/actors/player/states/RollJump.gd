extends PlayerInfo


@export var timerDuration: Timer
@export var timerBufferJump: Timer
@export var timerBufferRoll: Timer
@export var soundeffect: AudioStreamPlayer
@export var particles: GPUParticles2D

@export var duration: float = 1.0
@export var jumpModifier: float = 0.25
@export var velocityModifier: float = 2.0

var velocityRollJump: float
var startingHeight: int


func enter() -> void:
	velocityRollJump = moveSpeed * velocityModifier
	startingHeight = player.global_position.y
	EventBus.playerJumped.emit()
	topSpeed = 0
	neutral_move_direction_logic()
	player.animPlayer.queue("Roll")
	soundeffect.pitch_scale = jumpModifier
	soundeffect.play()
	if player.is_on_floor():
		particles.restart()
	player.global_position.y -= Util.tileSize * 2
	player.velocity.x = velocityRollJump * player.facing
	timers()


func exit() -> void:
	player.animPlayer.stop()
	soundeffect.pitch_scale = 1


func physics(delta) -> void:
	
	player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide_rotation()
	
	if timerDuration.is_stopped():
		gravity_logic(gravityJump, delta)
	else:
		player.velocity.y = 0
	
	if player.neutralMoveDirection:
		neutral_move_direction_logic()
		if abs(player.velocity.x) < velocityRollJump:
			player.velocity.x = move_toward(abs(player.velocity.x), velocityRollJump, (moveSpeed * 3) * delta) * player.facing
	else:
		if player.moveDirection.x != 0:
			if player.moveDirection.x != player.facing:
#				player.velocity.x = move_toward(player.velocity.x, 0, (moveSpeed * 2) * delta)
				apply_friction(moveSpeed * 2, delta)
			elif player.moveDirection.x == player.facing and abs(player.velocity.x) < velocityRollJump:
#					apply_acceleration(velocityLongJump, moveSpeed * 3, delta) #TODO: make func to input direction
					player.velocity.x = move_toward(abs(player.velocity.x), velocityRollJump, (moveSpeed * 3) * delta) * player.facing
	
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	squash_and_stretch(delta)
	player.facing_logic()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		if abilities.can_use(PlayerAbilities.list.JumpAir) and !(player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding()):
			player.velocity.x = 0
			return State.JumpAir
		else:
			timerBufferJump.start()
			player.velocity.x = 0
			return State.Fall
	if Input.is_action_just_pressed("roll"):
		timerBufferRoll.start()
	if Input.is_action_just_pressed("glide")  and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive")  and abilities.can_use(PlayerAbilities.list.Dive):
		return State.Dive
	if Input.is_action_just_pressed("ground_pound"):
		if abilities.can_use(PlayerAbilities.list.GroundPound): 
			return State.GroundPound
		else: #TODO: find a better way to cancel
			return State.Fall
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashSide):
		abilities.consume(PlayerAbilities.list.DashSide, 1)
		return State.DashAir
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if Input.is_action_just_pressed("bash") and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if player.global_position.y > startingHeight: ## leave state when passing starting height
		return State.Fall
	if player.is_on_ceiling():
		return State.Fall
	if player.is_on_wall():
		if topSpeed > moveSpeed:
			topSpeed = 0
			return State.BonkAir
		else:
			return State.WallLand
	if player.is_on_floor():
		if !timerDuration.is_stopped():
			return State.Roll
		if !timerBufferRoll.is_stopped():
			timerBufferRoll.stop()
			return State.Roll
		else:
			player.landed()
			if player.velocity.x != 0:
				return State.Walk
			else:
				return State.Idle

	return State.Null


func timers () -> void:
	timerDuration.wait_time = duration
	timerDuration.start()
