extends BaseMenu

func enter() -> void:
	set_paused(false)
	#FIXME: call input update after exiting menu


func exit() -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("ui_pause"):
		return State.Paused
	if Input.is_action_just_pressed("debug_menu"):
		return State.Debug
#	if Input.is_action_just_pressed("ui_info"):
#		#TODO: change to map or something else later
#		return State.FastTravel
	
	return State.Null


func state_check() -> int:
	return State.Null
