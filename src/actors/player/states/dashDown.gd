extends PlayerInfo


@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer

@export var duration: float = 0.3
@export var durationTimer: Timer
@export var chainTimer: Timer
@export var floorTime: float = 0.1
@export var particles: GPUParticles2D
@export var soundJetpack: AudioStreamPlayer


func enter() -> void:
	soundJetpack.play()
	EventBus.playerDashed.emit()
	player.velocityPrevious = player.velocity
	timers()
	player.animPlayer.queue("Dash Down")
	particles.local_coords = true
	particles.emitting = true
	player.velocity.x = 0
	player.velocity.y = dashVelocity
	player.ability_mask(CollisionLayers.DashDown, false)


func exit() -> void:
	soundJetpack.stop()
	player.animPlayer.stop()
	particles.local_coords = false
	particles.emitting = false
	player.velocity.y = player.velocity.y/4
	player.ability_mask(CollisionLayers.DashDown, true)


func physics(delta) -> void:
	player.move_and_slide()
	gravity_logic(gravityFall, delta)


func visual(delta) -> void:
	pass


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
			player.velocity.y = 0 #Gives more air control when canceling 
			return State.Fall
	if Input.is_action_just_pressed("glide") and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive") and abilities.can_use(PlayerAbilities.list.Dive):
		return State.Dive
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashSide):
		abilities.consume(PlayerAbilities.list.DashSide, 1)
		if player.is_on_floor():
			EventBus.rumble.emit(0.1, 0.2, 0.2)
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
	var floorTimer: float
	floorTimer = floorTime
	if player.is_on_ceiling():
		return State.Fall
	if player.is_on_floor():
		floorTimer -= delta
		if floorTimer < 0 or durationTimer.is_stopped():
			return State.GroundPoundLand
#	if durationTimer.is_stopped():
#		return State.Fall

	return State.Null


func timers() -> void:
#	durationTimer.wait_time = duration
#	durationTimer.start()
	chainTimer.start()
