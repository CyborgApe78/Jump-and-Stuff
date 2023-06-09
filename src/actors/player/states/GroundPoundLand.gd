extends PlayerInfo


@export var timerStun: Timer
@export var timerCharge: Timer

@export var stunDuration: float = 0.6


func enter() -> void:
	#particles.restart()
	abilities.reset(PlayerAbilities.list.JumpAir)
	abilities.reset(PlayerAbilities.list.Dash)
	abilities.reset(PlayerAbilities.list.DashChain)
	player.sounds.land.play()
	Input.start_joy_vibration(0, 0.5, 0.7, 0.5) #TODO: create signal
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
			return State.Slide #TODO: special state for redirecting block break
		else:
			return State.Idle

	return State.Null
