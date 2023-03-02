extends BaseMenu


@onready var resumeButton: Button = $"%Resume"
var CheckpointSystem: Resource = preload("res://src/resources/CheckpointSystem.tres")


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


func _on_settings_pressed() -> void:
	EventBus.menuChanged.emit(State.Settings)


func _on_reset_pressed() -> void:
	EventBus.menuChanged.emit(State.Unpaused)
	CheckpointSystem.reset_checkpoint()
	get_tree().reload_current_scene()


func _on_resume_pressed() -> void:
	EventBus.menuChanged.emit(State.Unpaused)


func _on_controls_pressed() -> void:
	EventBus.menuChanged.emit(State.Controls)


