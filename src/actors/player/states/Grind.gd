extends PlayerInfo

#LOOKAT: get the rail node and move progress on follow, look at modern sonic to get velocity equation
## add match states for above, below, crouch, roll and dash

enum state {above, below, crouch, dash}

var currentState: int


func enter() -> void:
	player.velocity = Vector2.ZERO
	abilities.reset(PlayerAbilities.listUse.All)


func exit() -> void:
	pass


func physics(delta) -> void:
	match currentState:
		state.above:
			pass
		state.below:
			pass
		state.crouch:
			pass
		state.dash:
			pass


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justPressedJump:
		return State.Jump
	
	match currentState:
		state.above:
			if input.justPressedDown:
				player.global_position.y = player.global_position.y + 128 ## will be capped with match state
				currentState = state.below
		state.below:
			if input.justPressedUp:
				player.global_position.y = player.global_position.y - 128 ## will be capped with match state
				currentState = state.above
	
#	if input.pressedCrouch: ## find a better way to play anims
#		player.animPlayer.play("Crouch")
#	else:
#		player.animPlayer.play("Idle")

	return State.Null


func state_check(delta: float) -> int:
	

	return State.Null
