extends VBoxContainer


var WaypointSystem: Resource = preload("res://src/resources/WaypointSysten.tres")


func _on_up_pressed() -> void:
	EventBus.teleportPlayer.emit(WaypointSystem.locations.Up)


func _on_down_pressed() -> void:
	EventBus.teleportPlayer.emit(WaypointSystem.locations.Down)
