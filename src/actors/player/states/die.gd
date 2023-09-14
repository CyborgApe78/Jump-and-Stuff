extends PlayerInfo

#TODO: make state work

func enter() -> void:
	EventBus.playerDied.emit()


func exit() -> void:
	if CheckpointSystem.currentRespawn != Vector2.ZERO:
		player.global_position = CheckpointSystem.currentRespawn
	else:
		get_tree().reload_current_scene()
		EventBus.emit_signal("error", str("no spawn point set"))


func physics(_delta) -> void:
	pass	


func visual(_delta) -> void:
	pass


func sound(_delta: float) -> void:
	pass


func handle_input(_event: InputEvent) -> int:
	

	return State.Null


func state_check(_delta: float) -> int:
	return State.Spawn

#	return State.Null
