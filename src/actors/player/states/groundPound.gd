extends PlayerInfo
#TODO: different states depending on if ground pound is held when touching ground. 
@export var groundPoundModifier: float = 2.0


func enter() -> void:
	player.velocity.y = max(moveSpeed * groundPoundModifier, abs(player.velocity.y))


func exit() -> void:
	pass


func physics(delta) -> void:
	player.move_and_slide()
	player.velocity.x = 0


func visual(delta) -> void:
	squash_and_stretch(delta)
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("dive"):
		#TODO: special further dive
		return State.Dive

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_floor():
		player.landed()
		if !Input.is_action_pressed("ground pound"):
			return State.GroundPoundBounce
		else:
			if player.moveDirection.x != 0:
				return State.Walk
			else:
				return State.Idle

	return State.Null
