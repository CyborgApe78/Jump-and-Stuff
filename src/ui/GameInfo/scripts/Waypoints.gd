extends MarginContainer

@export var buttonUp: Button
@export var buttonDown: Button

var WaypointSystem: Resource = preload("res://src/resources/WaypointSysten.tres")
#TODO: exit menu


#func update_waypoints() -> void:
#	buttonUp.visible = WaypointSystem.unlockedUp
#	buttonDown.visible = WaypointSystem.unlockedDown


func _on_up_pressed() -> void:
	EventBus.teleportPlayer.emit(WaypointSystem.locations.Starting)


func _on_down_pressed() -> void:
	EventBus.teleportPlayer.emit(WaypointSystem.locations.Platforms)
