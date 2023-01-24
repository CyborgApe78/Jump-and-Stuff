extends BaseMenu


func _ready() -> void:
	pass


func enter() -> void:
	set_paused(true)
	visible = true



func exit() -> void:
	set_paused(false)
	visible = false


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("ui_pause") or Input.is_action_just_pressed("ui_back"):
		return State.Unpaused
	
	return State.Null


func state_check() -> int:
	
	return State.Null
