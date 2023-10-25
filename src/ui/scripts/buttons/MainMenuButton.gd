extends ButtonBase


func _on_pressed() -> void:
	Utility.set_paused(false)
	get_tree().change_scene_to_file("res://src/ui/MainMenu/MainMenu.tscn")


func _on_focus_entered() -> void:
	super._on_focus_entered()


func _on_mouse_entered() -> void:
	super._on_mouse_entered()
