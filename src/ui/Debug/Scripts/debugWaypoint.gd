extends VBoxContainer


var wSystem: Resource = preload("res://src/resources/WaypointSysten.tres")


func _on_up_pressed() -> void:
	EventBus.teleportPlayer.emit(wSystem.locations.Up)


func _on_down_pressed() -> void:
	EventBus.teleportPlayer.emit(wSystem.locations.Down)
