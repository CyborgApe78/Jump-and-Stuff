extends BaseMenu

@export var menuStats: Control

func enter() -> void:
	set_paused(true)
	visible = true
	menuStats.stat_update()
	#FIXME: call input update after exiting menu


func exit() -> void:
	visible = false


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("ui_pause") or Input.is_action_just_pressed("ui_back") or Input.is_action_just_pressed("ui_info"):
		return State.Unpaused
	
	return State.Null


func state_check() -> int:
	return State.Null
