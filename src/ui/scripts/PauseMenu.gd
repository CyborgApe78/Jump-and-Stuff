extends BaseMenu


@onready var resumeButton: Button = $"%Resume"


func enter() -> void:
	set_paused(true)
	self.visible = true
	resumeButton.grab_focus()


func exit() -> void:
	self.visible = false


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("ui_pause") or Input.is_action_just_pressed("ui_back"):
		return State.Unpaused
	
	return State.Null


func state_check() -> int:
	return State.Null


func settings_button_pressed() -> void:
	EventBus.emit_signal("menuChanged", State.Settings)
	#TODO: change to built in signal


func _on_reset_pressed() -> void:
	EventBus.emit_signal("menuChanged", State.Unpaused)
	get_tree().reload_current_scene()


func _on_resume_pressed() -> void:
	EventBus.emit_signal("menuChanged", State.Unpaused)
