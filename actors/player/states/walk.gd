class_name PlayerWalk extends MachineState


@export var skidPercent: float = .8

@export_group("Sound")
@export_range(0.1, 1, 0.01) var minPlaybackSpeed: float = 0.15
@export_range(0.1, 1, 0.01) var maxPlaybackSpeed: float = 0.5
@export_range(0.1, 1, 0.01) var minPitch: float = 0.9
@export_range(0.1, 2, 0.01) var maxPitch: float = 1.1
@export_range(-2, 1, 0.01) var minVolume: float = -2
@export_range(0, 2, 0.01) var maxVolume: float = 2
@export var startingVolume: float = -15

@export_group("Particles")
@export_range(0.1, 1, 0.1) var particlesBaseDuration: float = 0.1
@export_range(0.1, 1, 0.1) var particlesBaseMaxDuration: float = 0.4
@export_range(1, 100, 1) var particlesBaseAmount: int = 4
@export_range(1, 100, 1) var particlesMaxAmount: int = 16

@export_group("States")
@export var idle: PlayerIdle
@export var jump: PlayerJump
@export var skid: PlayerSkid

@export_group("Connections")
@export var particles: GPUParticles2D
@export var soundeffect: AudioStreamPlayer
@export var stepTimer: Timer


func ready() -> void:
	pass


func enter() -> void:
	print("Walk")
	
	particles.emitting = true
	
	soundeffect.volume_db = startingVolume
	soundeffect.play()
	
	stepTimer.wait_time = remap(abs(player.velocity.x), stats.moveSpeed, 0,  minPlaybackSpeed, maxPlaybackSpeed)
	stepTimer.start()


func exit(_next_state: MachineState) -> void:
	particles.emitting = false
	stepTimer.stop()
	soundeffect.stop()


func handle_input(_event: InputEvent):
	if Input.is_action_just_pressed("jump"):
		FSM.change_state_to(jump)


func physics_update(_delta: float):
	if abs(player.velocity.x) > stats.moveSpeed * skidPercent and inputs.moveDirection.x != 0 and (sign(player.velocity.x) != inputs.moveDirection.x):
		FSM.change_state_to(skid)
	elif player.velocity.x != 0 and sign(player.velocity.x) != inputs.lastMoveDirection.x: ## kill velocity when changing directions
		player.velocity.x = inputs.lastMoveDirection.x * 1
	elif inputs.moveDirection.x != 0 and abs(player.velocity.x) < stats.moveSpeed:
		velocity.apply_acceleration(stats.moveSpeed, stats.accelerationGround, _delta)
	elif inputs.moveDirection.x == 0:
		velocity.apply_friction(stats.frictionGround, _delta)
	elif abs(player.velocity.x) >= stats.moveSpeed:
		velocity.momentum_logic(stats.moveSpeed, true)


func state_update(_delta: float):
	if player.velocity.x == 0:
		FSM.change_state_to(idle)


func visual_update(_delta: float):
	player.facing_logic(inputs.moveDirection.x)
	characterRig.speed_bend(true)
	particles.lifetime = remap(abs(player.velocity.x), 0, stats.moveSpeed, particlesBaseDuration, particlesBaseMaxDuration)
	particles.amount = remap(abs(player.velocity.x), 0, stats.moveSpeed, particlesBaseAmount, particlesMaxAmount)


func sound_update(_delta: float):
	pass


func _on_step_timer_timeout() -> void:
	soundeffect.pitch_scale = 1
	soundeffect.volume_db = startingVolume
	
	stepTimer.wait_time = remap(abs(player.velocity.x), stats.moveSpeed, 0,  minPlaybackSpeed, maxPlaybackSpeed)
	soundeffect.pitch_scale = randf_range(minPitch, maxPitch)
	soundeffect.volume_db += randf_range(minVolume, maxVolume)
	
	soundeffect.play()
	stepTimer.start()
