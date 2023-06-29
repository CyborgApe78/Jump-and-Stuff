extends StaticBody2D


func _ready() -> void:
	for shapes in get_children():
		shapes.one_way_collision = true

