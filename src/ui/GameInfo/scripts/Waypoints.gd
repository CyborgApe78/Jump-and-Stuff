extends MarginContainer

@export var buttonUp: Button
@export var buttonDown: Button

var wSystem: Resource = preload("res://src/resources/WaypointSysten.tres")
#TODO: exit menu


#func update_waypoints() -> void:
#	buttonUp.visible = wSystem.unlockedUp
#	buttonDown.visible = wSystem.unlockedDown


func _on_up_pressed() -> void:
	EventBus.teleportPlayer.emit(wSystem.locations.Starting)


func _on_down_pressed() -> void:
	EventBus.teleportPlayer.emit(wSystem.locations.Platforms)
