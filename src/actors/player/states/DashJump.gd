extends PlayerInfo

#lookat: maybe triggered like shinespark

@export_group("Connections")
@export var timerBufferJump: Timer
@export var durationTimer: Timer
@export var particles: GPUParticles2D
@export var soundJetpack: AudioStreamPlayer

@export_group("")
@export var duration: float = 0.3


func enter() -> void:
	soundJetpack.play()
	EventBus.playerDashed.emit()
	player.velocityPrevious = player.velocity
	timers()
	particles.local_coords = true
	particles.emitting = true
	
	##TODO: make aim direction like it is in grapple and bash detectors
	if input.aimDirection == Vector2.ZERO:
		player.velocity = Vector2.UP * stats.dashSpeed * 1.6
	else:
		player.velocity = input.aimDirection * stats.dashSpeed * 1.6


func exit() -> void:
	soundJetpack.stop()
	particles.local_coords = false
	particles.emitting = false


func physics(delta) -> void:
	player.move_and_slide()


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justPressedJump:
		if abilities.can_use(PlayerAbilities.list.JumpAir):
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
#	if input.justPressedDash: #TODO: add back with lockout timer
#		dash_pressed_buffer()
	if input.justPressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_ceiling() or player.is_on_wall():
		return State.BonkAir
	if durationTimer.is_stopped():
		return State.Fall
	if dashBufferState != State.Null:
		if dashBufferState == State.DashAir and abilities.can_use(PlayerAbilities.list.DashSide):
			return State.DashAir
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			return State.DashUp
		if dashBufferState == State.DashDown and abilities.can_use(PlayerAbilities.list.DashDown):
			return State.DashDown

	return State.Null


func timers() -> void:
	durationTimer.wait_time = duration
	durationTimer.start()
