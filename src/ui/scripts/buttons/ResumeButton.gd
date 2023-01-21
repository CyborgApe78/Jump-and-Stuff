extends Button


func _on_pressed() -> void:
	EventBus.emit_signal("returnToGame")
