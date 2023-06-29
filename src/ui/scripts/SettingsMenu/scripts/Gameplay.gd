extends VBoxContainer


@export var buttonAimIndicator: CheckButton
@export var buttonRumble: CheckButton
var settings: Resource = preload("res://src/resources/SettingsConfig.tres")


func _ready() -> void:
	update_menu()


func update_menu() -> void:
	buttonAimIndicator.button_pressed = settings.showAimIndicator
	buttonRumble.button_pressed = settings.rumble


func show_aim_indicator(toggled: bool) -> void:
	settings.showAimIndicator = toggled


func _on_rumble_toggled(toggled: bool) -> void:
	settings.rumble = toggled
