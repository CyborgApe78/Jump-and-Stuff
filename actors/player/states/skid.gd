class_name PlayerSkid extends MachineState

## slide after the player quickly changes directions
## Currently velocity based, might need to switch to duration for reliable controls
 

@export_range(0.1, 5, 0.1) var frictionMultiplier: float = 1.2

@export_group("Particles")
@export_range(0.1, 1, 0.1) var particlesBaseDuration: float = 0.1
@export_range(0.1, 1, 0.1) var particlesBaseMaxDuration: float = 0.3
@export_range(1, 100, 1) var particlesBaseAmount: int = 12
@export_range(1, 100, 1) var particlesMaxAmount: int = 24

@export_group("States")
@export var Walk: PlayerWalk
@export var Idle: PlayerIdle
@export var Jump: PlayerJump

@export_group("Connections")
@export var particles: GPUParticles2D
@export var soundeffect: AudioStreamPlayer


func ready() -> void:
	pass


func enter() -> void:
	print("Skid")
	player.facing_logic(inputs.lastMoveDirection.x)
	
	soundeffect.pitch_scale = randf_range(0.9, 1.1)
	soundeffect.play()
	
	particles.lifetime = remap(abs(player.velocity.x), 0, stats.moveSpeed, particlesBaseDuration, particlesBaseMaxDuration)
	particles.amount = remap(abs(player.velocity.x), 0, stats.moveSpeed, particlesBaseAmount, particlesMaxAmount)
	particles.restart()
	
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(player.characterRig, "skew", player.facing * 0.3, transformTime).from_current()


func exit(_next_state: MachineState) -> void:
	soundeffect.stop()
	particles.emitting = false


func handle_input(_event: InputEvent):
	if Input.is_action_just_pressed("jump"):
		FSM.change_state_to(Jump)


func physics_update(_delta: float):
	velocity.apply_friction(stats.frictionGround * frictionMultiplier, _delta)


func state_update(_delta: float):
	if abs(player.velocity.x) == 0:
		FSM.change_state_to(Idle)


func visual_update(_delta: float):
	characterRig.speed_bend(true, stats.moveSpeed, 0.3)


func sound_update(_delta: float):
	pass
