extends Button

#TODO: make this inherited from all other buttons


func _on_focus_entered() -> void:
	send_data()


func _on_mouse_entered() -> void:
	send_data()

func send_data() -> void:
	EventBus.cursorPosition.emit(global_position, position, size)
