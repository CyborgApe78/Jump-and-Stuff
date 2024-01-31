extends Path2D


#TODO: add top/bottom to hang on

@export var detector: Area2D
@export var collision: CollisionPolygon2D
@export var line: Line2D


func _ready() -> void:
	line.default_color = GameColor.climbColor
	if curve != null:
		line.points = curve.get_baked_points()
		await get_tree().process_frame
		var line_poly = Geometry2D.offset_polyline(line.points, line.width / 2, Geometry2D.JOIN_ROUND, Geometry2D.END_ROUND)
		for poly in line_poly:
			collision.polygon = poly
	else:
		EventBus.error.emit(str("Climbable null: " + str(name) + " at " + str(global_position)))


func body_entered(body: Player) -> void:
	body.Climbable = true #TODO: move to player


func body_exit(body: Player) -> void:
	body.Climbable = false
