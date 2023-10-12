extends PlayerInfo


@export var timerBufferJump: Timer
@export var timerCoyoteJumpWall: Timer
@export var particles: GPUParticles2D
@export var soundJetpack: AudioStreamPlayer

var duration: float = 0.3
var dashDirection: int


func enter() -> void:
	EventBus.playerDashed.emit()
	soundJetpack.play()
	player.animPlayer.queue("Dash Side Air")
	dashDirection = -wall.wall_detection(30)
	player.velocityPrevious = player.velocity
	particles.local_coords = true
	particles.emitting = true
	player.velocity.y = 0
#	player.velocity = input.aimDirection * dashVelocity * 1.6 #TODO: aimable upgrade
	player.velocity.x = dashDirection * stats.dashSpeed
	player.characterRig.scale.x = dashDirection
	player.ability_mask(CollisionLayers.DashSide, false)


func exit() -> void:
	soundJetpack.stop()
	player.animPlayer.stop()
	particles.local_coords = false
	particles.emitting = false
	if input.moveDirection.x != 0:
		player.velocity.x = player.velocityPrevious.x
	player.ability_mask(CollisionLayers.DashSide, true)

func physics(delta) -> void:
	player.move_and_slide()
	velocity.track_top_speed(player.velocity.x)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	if !soundJetpack.playing:
		soundJetpack.play()


func handle_input(event: InputEvent) -> int:
	if input.justPressedJump:
		timerCoyoteJumpWall.start()
		if abilities.can_use(PlayerAbilities.list.JumpAir) and !(ground.detectorGroundLeft.is_colliding() or ground.detectorGroundRight.is_colliding()):
			return State.JumpAir
		else:
			timerBufferJump.start()
			return State.Fall
	if input.justPressedGlide and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Dive):
		return State.Dive
	if input.justPressedCrouch and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
	if input.justPressedDash:
		dash_pressed_buffer()
	if input.justPressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall(): 
		if !timerCoyoteJumpWall.is_stopped():
			return State.JumpWall
		elif velocity.topSpeed > stats.moveSpeed:
			velocity.topSpeed = 0
			return State.BonkAir
	if dashBufferState != State.Null:
		if dashBufferState == State.DashAir and abilities.can_use(PlayerAbilities.list.DashSide):
			return State.DashAir
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			return State.DashUp
		if dashBufferState == State.DashDown and abilities.can_use(PlayerAbilities.list.DashDown):
			return State.DashDown

	return State.Null
