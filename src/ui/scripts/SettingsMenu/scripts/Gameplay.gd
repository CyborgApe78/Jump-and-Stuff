extends VBoxContainer

#TODO: toggle should be on to the left and off to the right

@export var buttonAimIndicator: CheckButton
var SettingsFile: Resource = preload("res://src/resources/SettingsConfig.tres")


func _ready() -> void:
	update_menu()


func update_menu() -> void:
	buttonAimIndicator.button_pressed = SettingsFile.showAimIndicator


func show_aim_indicator(toggled: bool) -> void:
	SettingsFile.showAimIndicator = toggled
