extends ButtonBase


func _on_pressed():
	OS.shell_open("https://discord.gg/6SJyu4NtfW")


func send_data() -> void:
	EventBus.cursorPosition.emit(global_position, position, size)
