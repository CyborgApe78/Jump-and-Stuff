extends VBoxContainer


@export var timerCheck: CheckButton
@export var buttonController: CheckButton
var SettingsFile: Resource = preload("res://src/resources/SettingsConfig.tres")


func _ready() -> void:
	update_menu()


func update_menu() -> void:
	timerCheck.button_pressed = SettingsFile.showTimer
	buttonController.button_pressed = SettingsFile.showController


func show_timer(toggled: bool) -> void:
	SettingsFile.showTimer = toggled


func show_controller(toggled: bool) -> void:
	SettingsFile.showController = toggled
