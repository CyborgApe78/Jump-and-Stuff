extends Control


@export var showCollision: Button


func _on_collision_toggled(button_pressed: bool) -> void:
	EventBus.debug.emit("Placeholder") #TODO
