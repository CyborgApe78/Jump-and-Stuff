extends BaseMenu


@export var feedback: Control
@export var cursor: Panel
@export var firstButton: ButtonBase

@onready var resumeButton: Button = $"%Resume"

var cpSystem: Resource = preload("res://src/resources/CheckpointSystem.tres")


func enter() -> void:
	feedback.visible = false
	set_paused(true)
	self.visible = true
	firstButton.grab_focus()
	await get_tree().process_frame
	firstButton.send_data()


func exit() -> void:
	cursor.visible = false
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
	cpSystem.reset_checkpoint()
	get_tree().reload_current_scene()


func _on_resume_pressed() -> void:
	EventBus.menuChanged.emit(State.Unpaused)


func _on_controls_pressed() -> void:
	EventBus.menuChanged.emit(State.Controls)


func _on_feedback_pressed() -> void:
	feedback.visible = !feedback.visible
