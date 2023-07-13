extends Button


func _on_pressed() -> void:
	Utility.set_paused(false)
	get_tree().change_scene_to_file("res://src/ui/MainMenu/MainMenu.tscn")
