extends PlayerInfo


@export var timerStun: Timer
@export var timerCharge: Timer
@export var particles: GPUParticles2D
@export var soundeffect: AudioStreamPlayer

@export var stunDuration: float = 0.3


func enter() -> void:
	#particles.restart()
	abilities.reset(PlayerAbilities.list.JumpAir)
	abilities.reset(PlayerAbilities.list.Dash)
	abilities.reset(PlayerAbilities.list.DashChain)
	soundeffect.play()
	particles.restart()
	Input.start_joy_vibration(0, 0.3, 0.5, 0.3) #TODO: create signal
	timerStun.wait_time = stunDuration
	timerStun.start()
	player.animPlayer.queue("Crouch")


func exit() -> void:
	pass


func physics(delta) -> void:
	pass


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump") and abilities.can_use(PlayerAbilities.list.GroundPoundBounce): #TODO: change to charge
		return State.GroundPoundBounce

	return State.Null


func state_check(delta: float) -> int:
	if timerStun.is_stopped():
		if player.moveDirection.x != 0:
			return State.Walk
		else:
			return State.Idle

	return State.Null
