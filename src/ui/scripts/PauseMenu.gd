extends BaseMenu


@onready var resumeButton: Button = $"%Resume"
@onready var settingsButton: Button = $"%Settings"


func _ready() -> void:
	resumeButton.connect("pressed", resume_button_pressed)
	settingsButton.connect("pressed", settings_button_pressed)


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


func resume_button_pressed() -> void:
	EventBus.emit_signal("menuChanged", State.Unpaused)
