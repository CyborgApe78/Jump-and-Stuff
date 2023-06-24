extends PlayerInfo


@export var timerBufferJump: Timer

var duration: float = 0.3
@export var particles: GPUParticles2D
@export var soundJetpack: AudioStreamPlayer


func enter() -> void:
	EventBus.playerDashed.emit()
	soundJetpack.play()
	player.velocityPrevious = player.velocity
	particles.local_coords = true
	particles.emitting = true
	player.velocity.y = -dashVelocity
	player.velocity.x = 0
	player.ability_mask(CollisionLayers.DashUp, false)


func exit() -> void:
	soundJetpack.stop()
	particles.local_coords = false
	particles.emitting = false 
	player.ability_mask(CollisionLayers.DashUp, true)

func physics(delta) -> void:
	player.move_and_slide()


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		if abilities.can_use(PlayerAbilities.list.JumpAir):
			return State.JumpAir
		else:
			timerBufferJump.start()
			return State.Fall
	if Input.is_action_just_pressed("grab"):
		return State.WallGrab
	if Input.is_action_just_pressed("dive") and abilities.can_use(PlayerAbilities.list.Dive):
		return State.Dive
	if Input.is_action_just_pressed("ground_pound") and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashSide):
		abilities.consume(PlayerAbilities.list.DashSide, 1)
		return State.DashAir

	return State.Null


func state_check(delta: float) -> int:
	if !player.is_on_wall():
		return State.Fall
	if player.is_on_ceiling():
		return State.WallSlide

	return State.Null
