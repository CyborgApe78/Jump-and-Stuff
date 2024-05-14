extends Control
class_name BaseSettingsMenu


@export var buttonFirst: Button

func enter()-> void:
	if buttonFirst != null:
		buttonFirst.grab_focus()
	visible = true
