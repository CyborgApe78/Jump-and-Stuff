extends Polygon2D

## Create collision shape from polygon

@onready var parent = get_parent()

func _ready() -> void:
	var coll := CollisionPolygon2D.new()
	coll.polygon = polygon
	parent.add_child.call_deferred(coll)
	coll.position = position
