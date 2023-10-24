extends PlayerInfo

#TODO: look at combining with spin. like mario screw
#TDOO: similar to swimming, but don't stop moving
#TODO: also need to dash into water

@export_group("Connections")

@export_group("")


func enter() -> void:
	player.animPlayer.queue("Swim") #TODO: own animation


func exit() -> void:
	player.animPlayer.stop()


func physics(delta) -> void:
	player.move_and_slide()


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	

	return State.Null


func state_check(delta: float) -> int:
	

	return State.Null
