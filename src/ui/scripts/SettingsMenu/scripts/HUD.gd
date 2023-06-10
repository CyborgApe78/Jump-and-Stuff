extends VBoxContainer

@export var hideHUD: CheckButton
@export var timerCheck: CheckButton
@export var buttonController: CheckButton
var SettingsFile: Resource = preload("res://src/resources/SettingsConfig.tres")


func _ready() -> void:
	update_menu()


func update_menu() -> void:
	hideHUD.button_pressed = SettingsFile.hideHUD
	timerCheck.button_pressed = SettingsFile.showTimer
	buttonController.button_pressed = SettingsFile.showController


func hide_hud(toggled: bool) -> void:
	SettingsFile.hideHUD = toggled


func show_timer(toggled: bool) -> void:
	SettingsFile.showTimer = toggled


func show_controller(toggled: bool) -> void:
	SettingsFile.showController = toggled
