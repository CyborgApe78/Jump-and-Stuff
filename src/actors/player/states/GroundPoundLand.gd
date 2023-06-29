extends PlayerInfo


@export var timerStun: Timer
@export var timerCharge: Timer
@export var particles: GPUParticles2D
@export var soundeffect: AudioStreamPlayer

@export var stunDuration: float = 0.2


func enter() -> void:
	abilities.reset(PlayerAbilities.list.JumpAir)
	abilities.reset(PlayerAbilities.list.Dash)
	abilities.reset(PlayerAbilities.list.DashChain)
	soundeffect.play()
	particles.restart()
	EventBus.rumble.emit(0.3, 0.5, 0.3)
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
	if Input.is_action_just_pressed("jump"):
		return State.JumpCrouch #TODO: own state
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.GroundPoundBounce): #TODO: change to charge
		return State.DashGroundPound
	
	return State.Null


func state_check(delta: float) -> int:
	if timerStun.is_stopped():
		if Input.is_action_pressed("crouch"):
			return State.Crouch
		if player.moveDirection.x != 0:
			return State.Walk
		else:
			return State.Idle

	return State.Null
