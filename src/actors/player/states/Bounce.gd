extends PlayerInfo

#TODO: let go of jump to cancel

func enter() -> void:
	player.velocity = velocity.bounceVelocity


func exit() -> void:
	pass


func physics(delta) -> void:
	player.move_and_slide()
	
	velocity.gravity_logic(stats.gravityFall, delta)


func visual(delta) -> void:
	if input.aimBackup.x != 0:
		player.facing_logic(input.aimBackup.x)


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	

	return State.Null


func state_check(delta: float) -> int:
	

	return State.Null
