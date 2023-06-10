extends CanvasLayer


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_debug"):
		visible = !visible
