extends Button

#FIXME: button is skipped


func _on_pressed() -> void:
	Utility.set_paused(false)
	get_tree().change_scene_to_file("res://src/ui/MainMenu/MainMenu.tscn")


func _on_focus_entered() -> void:
	pass # Replace with function body.


func _on_mouse_entered() -> void:
	pass # Replace with function body.
