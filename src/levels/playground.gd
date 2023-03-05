extends Node


var CheckpointSystem: Resource = preload("res://src/resources/CheckpointSystem.tres")


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("reset"): #TODO: reset button on controller
		CheckpointSystem.reset_checkpoint() 
		get_tree().reload_current_scene()
