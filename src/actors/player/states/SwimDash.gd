extends PlayerInfo

#TODO: should have a timer to boost out of water
#LOOKAT: change name since it will work with burrow

@export_group("Connections")

@export_group("")


func enter() -> void:
	pass


func exit() -> void:
	pass


func physics(delta) -> void:
	pass


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	

	return State.Null


func state_check(delta: float) -> int:
	

	return State.Null
