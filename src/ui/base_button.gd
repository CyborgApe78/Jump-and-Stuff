extends Button
class_name ButtonBase

#FIXME: the cursor doesn't start in the correct place on pause menu
@export var cursor: Cursor

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	mouse_entered.connect(_on_mouse_entered)


func _on_focus_entered() -> void:
	send_data()


func _on_mouse_entered() -> void:
	send_data()


func send_data() -> void:
	print(self.name)
	cursor.on_focused(global_position, position, size)
