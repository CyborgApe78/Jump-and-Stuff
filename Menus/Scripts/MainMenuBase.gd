extends Control
class_name MainMenuBase


@export var buttonFirst: Button

## Sets button as focused
func _ready() -> void:
	if buttonFirst != null:
		buttonFirst.grab_focus()
