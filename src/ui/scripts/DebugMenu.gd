extends BaseMenu


@export var ability: VBoxContainer


func enter() -> void:
	EventBus.debugMenuOpened.emit(true) #TODO: change to menu, use to check in normal menus what is unlocked
	set_paused(true)
	visible = true
	ability.buttonAbilityAll.grab_focus()


func exit() -> void:
	EventBus.debugMenuOpened.emit(false)
	set_paused(false)
	visible = false


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("ui_pause") or Input.is_action_just_pressed("ui_back") or Input.is_action_just_pressed("debug_menu"):
		return State.Unpaused
	
	return State.Null


func state_check() -> int:
	return State.Null
