class_name PlayerFall extends MachineState


@export var jumpHeldSlowModifier: float = 2.0

@export_group("Sound")
@export_range(0.1, 1, 0.01) var minPlaybackSpeed: float = 0.15
@export_range(0.1, 1, 0.01) var maxPlaybackSpeed: float = 0.5
@export_range(0.1, 1, 0.01) var minPitch: float = 0.9
@export_range(0.1, 2, 0.01) var maxPitch: float = 1.1
@export_range(-2, 1, 0.01) var minVolume: float = -2
@export_range(0, 2, 0.01) var maxVolume: float = 2
@export var startingVolume: float = -15

@export_group("Particles")
@export_range(0.1, 1, 0.1) var particlesBaseDuration: float = 0.6
@export_range(0.1, 1, 0.1) var particlesBaseMaxDuration: float = 0.8
@export_range(1, 100, 1) var particlesBaseAmount: int = 16
@export_range(1, 100, 1) var particlesMaxAmount: int = 32

@export_group("States")
@export var Idle: PlayerIdle
@export var Walk: PlayerWalk
@export var Jump: PlayerJump

@export_group("Connections")
@export var landParticles: GPUParticles2D
@export var landSoundeffect: AudioStreamPlayer


func ready() -> void:
	pass


func enter() -> void:
	print("Fall")


func exit(_next_state: MachineState) -> void:
	pass


func handle_input(_event: InputEvent):
	pass


func physics_update(_delta: float):
	velocity.gravity_logic(stats.gravityFall, _delta)
	
	if Input.is_action_pressed("jump"):
		velocity.fall_speed_logic(stats.terminalVelocity / jumpHeldSlowModifier)
	elif inputs.moveDirection.y == 1:
		velocity.fall_speed_logic(stats.terminalVelocity * 1.5)
	else:
		velocity.fall_speed_logic(stats.terminalVelocity)
	
	velocity.air_velocity_logic(stats.moveSpeed, stats.accelerationAir, stats.frictionAir, _delta)


func state_update(_delta: float):
	if Input.is_action_just_pressed("jump") and inputs.canCoyoteJump == true:
		print("Coyote Jump")
		FSM.change_state_to(Jump)
	if player.is_on_floor():
		#TODO: Create Landed function
		
		landSoundeffect.volume_db = startingVolume
		landSoundeffect.pitch_scale = randf_range(minPitch, maxPitch)
		landSoundeffect.volume_db += randf_range(minVolume, maxVolume)
		landSoundeffect.play()
		
		landParticles.lifetime = remap(abs(player.velocity.y), 0, stats.terminalVelocity, particlesBaseDuration, particlesBaseMaxDuration)
		landParticles.amount = remap(abs(player.velocity.y), 0, stats.terminalVelocity, particlesBaseAmount, particlesMaxAmount)
		landParticles.restart()
		
		if player.velocity.x != 0:
			FSM.change_state_to(Walk)
		else:
			FSM.change_state_to(Idle)


func visual_update(_delta: float):
	player.facing_logic(inputs.moveDirection.x)
	characterRig.squash_and_stretch(_delta)


func sound_update(_delta: float):
	pass
