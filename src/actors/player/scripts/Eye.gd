@tool
extends Node2D


@export var eyeRadius: int = 2
@export var eyeOffset: int = 2

var transformTime: float = 0.2


func _ready() -> void:
	queue_redraw()



func _draw() -> void:
	draw_circle(position, eyeRadius * 3, Color.BLACK)
	draw_circle(position + Vector2(eyeOffset,-eyeOffset), eyeRadius, Color.WHITE)
