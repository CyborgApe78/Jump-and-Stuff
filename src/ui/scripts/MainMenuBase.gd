extends Control
class_name MainMenuBase


@export var firstButton: ButtonBase


func on_visible_focus() -> void:
	if firstButton:
		firstButton.grab_focus()
		await get_tree().process_frame
		firstButton.send_data()
