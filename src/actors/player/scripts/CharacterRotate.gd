@tool
extends Node2D


@onready var head: Node2D = $Head
@export var headRadius: int = 28

var transformTime: float = 0.2


func _ready() -> void:
	queue_redraw()



func _draw() -> void:
	draw_circle(head.position, headRadius * 1.1, Color.BLACK)
	draw_circle(head.position, headRadius, Color.PURPLE)
