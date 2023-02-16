extends Control


@export var showCollision: Button
@export var showDebugInfo: Button


func _on_collision_toggled(button_pressed: bool) -> void:
	EventBus.debug.emit("Placeholder") #TODO


func _on_debug_info_toggled(button_pressed: bool) -> void:
	EventBus.showDebug.emit(button_pressed) #TODO
