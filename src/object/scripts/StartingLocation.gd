extends Node2D


var CheckpointSystem: Resource = preload("res://src/resources/CheckpointSystem.tres")

func  _enter_tree() -> void:
	CheckpointSystem.startingArea = global_position

