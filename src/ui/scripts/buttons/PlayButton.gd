extends Button


@export var changeScene: PackedScene


func _ready() -> void:
	grab_focus()


func _on_pressed() -> void:
	get_tree().change_scene_to_packed(changeScene)


func _on_focus_entered() -> void:
	send_data()


func _on_mouse_entered() -> void:
	send_data()

func send_data() -> void:
	EventBus.cursorPosition.emit(global_position, position, size)
