extends CanvasLayer


var SettingsFile: Resource = preload("res://src/resources/SettingsConfig.tres")


func _ready() -> void:
	EventBus.settingsUpdate.connect(hide_hud)
	if not visible:
		visible = true


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_hud"):
		visible = !visible


func hide_hud() -> void:
	if SettingsFile.hideHUD:
		hide()
	else:
		show()
