extends PlayerInfo

#LOOKAT: get the rail node and move progress on follow, look at modern sonic to get velocity equation
#TODO: particles
#TODO: check when progress is 0 or 100 to exit
#TODO Need min speed on grid rail

enum state {above, below, crouch, dash}

var currentState: int

var speedEnter: float


func enter() -> void:
	speedEnter = player.velocity.x
	player.velocity.y = 0
	abilities.reset(PlayerAbilities.listUse.All)


func exit() -> void:
	player.velocity.x = speedEnter


func physics(delta) -> void:
	
	player.grindRailFollow.progress += speedEnter * delta
	
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
			if input.justPressedDown: #TODO: make this only work with grapple hook
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
	if player.grindRailFollow.progress_ratio == 1 and player.facing == 1:
		return State.Fall
	if player.grindRailFollow.progress_ratio == 0 and player.facing == -1:
		return State.Fall

	return State.Null
