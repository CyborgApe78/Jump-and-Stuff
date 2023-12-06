extends Node2D


var cpSystem: Resource = preload("res://src/resources/CheckpointSystem.tres")

func _ready() -> void:
	visible = false

func _enter_tree() -> void:
	cpSystem.startingArea = global_position

