extends PlayerInfo


@export_group("Connections")
@export var timerCoyoteJumpGroundPound: Timer
@export var timerStun: Timer
@export var timerCharge: Timer
@export var particles: GPUParticles2D
@export var soundeffect: AudioStreamPlayer

@export_group("")
@export var stunDuration: float = 0.2


func enter() -> void:
	abilities.reset(PlayerAbilities.list.JumpAir)
	abilities.reset(PlayerAbilities.list.Dash)
	abilities.reset(PlayerAbilities.list.DashChain)
	soundeffect.play()
	particles.restart()
	EventBus.rumble.emit(0.4, 0.6, 0.3)
	timerStun.wait_time = stunDuration
	timerStun.start()
	player.animPlayer.queue("Crouch")


func exit() -> void:
	timerCoyoteJumpGroundPound.start()


func physics(delta) -> void:
	pass


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justPressedJump and abilities.can_use(PlayerAbilities.list.JumpGroundPound):
		return State.JumpGroundPound
#	if input.justPressedDash and abilities.can_use(PlayerAbilities.list.DashGroundPound): #TODO: change to charge
#		return State.DashGroundPound
#	if (input.pressedLeft or input.pressedRight) and abilities.can_use(PlayerAbilities.list.GroundPoundKick): #TODO: add state
#		return State.GroundPoundKick
	
	return State.Null


func state_check(delta: float) -> int:
	if timerStun.is_stopped():
		if input.pressedCrouch:
			return State.Crouch
		if input.moveDirection.x != 0:
			return State.Walk
		else:
			return State.Idle

	return State.Null
