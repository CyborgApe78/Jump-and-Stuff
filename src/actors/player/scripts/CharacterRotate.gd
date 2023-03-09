@tool
extends Node2D


@onready var head: Node2D = $Head
@onready var eye: Node2D = $Eye

@export var headRadius: int = 28
@export var eyeRadius: int = 2
@export var eyeOffset: int = 2

var transformTime: float = 0.2


func _process(delta) -> void:
	queue_redraw()
	


func _draw() -> void:
	draw_circle(head.position, headRadius * 1.1, Color.BLACK)
	draw_circle(head.position, headRadius, Color.PURPLE)
	draw_circle(eye.position, eyeRadius * 3, Color.BLACK)
	draw_circle(eye.position + Vector2(eyeOffset,-eyeOffset), eyeRadius, Color.WHITE)
