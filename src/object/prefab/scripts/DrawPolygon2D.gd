@tool
extends Polygon2D
class_name VisibleCollisionPolygon2D



@onready var parent: CollisionPolygon2D = get_parent()


func _ready() -> void:
	polygon = parent.polygon
