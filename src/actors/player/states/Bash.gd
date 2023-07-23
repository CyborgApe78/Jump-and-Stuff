extends PlayerInfo


@export var timerDuration: Timer

@export var duration: float = 0.6

var aimInput: Vector2 #TODO: break aim indicator out so it can be used for other targets


func enter() -> void:
	timers()
	aimInput = player.aimStrength if player.aimStrength != Vector2.ZERO else player.moveStrength
	player.velocity = aimInput * (dashVelocity)
	abilities.reset(PlayerAbilities.list.All)


func exit() -> void:
	pass


func physics(delta) -> void:
	player.move_and_slide()
	
	


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	

	return State.Null


func state_check(delta: float) -> int:
	if timerDuration.is_stopped():
		if Input.is_action_just_pressed("glide") and abilities.can_use(PlayerAbilities.list.Glide):
			return State.Glide
		if !player.is_on_floor():
			if !player.moveDirection == Vector2.ZERO:
				player.velocity = player.velocity / 2
			return State.Fall
	if player.is_on_floor():
		return State.Walk
	

	return State.Null


func timers() -> void:
	timerDuration.wait_time = duration
	timerDuration.start()
