extends Node


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("reset"): #TODO: move elsewhere
		get_tree().reload_current_scene()
