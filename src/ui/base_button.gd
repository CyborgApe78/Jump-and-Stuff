extends Button
class_name ButtonBase

#FIXME: the cursor doesn't start in the correct place on pause menu
@export var firstButton: bool = false


func _ready() -> void:
	if firstButton:
		grab_focus()
		await get_tree().process_frame
		send_data()


func _on_focus_entered() -> void:
	send_data()


func _on_mouse_entered() -> void:
	send_data()


func send_data() -> void:
	EventBus.cursorPosition.emit(global_position, position, size)
