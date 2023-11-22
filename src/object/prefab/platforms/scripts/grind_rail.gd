extends Path2D


@export var rail: Line2D
@export var detector: Area2D
@export var colision: CollisionPolygon2D
@export var remote: RemoteTransform2D


func _ready() -> void:
	rail.default_color = AbilityColor.RailColor
	if curve != null:
		rail.points = curve.get_baked_points()
		await get_tree().process_frame
		var line_poly = Geometry2D.offset_polyline(rail.points, rail.width / 2, Geometry2D.JOIN_ROUND, Geometry2D.END_ROUND)
		for poly in line_poly:
			colision.polygon = poly
	else:
		EventBus.error.emit(str("Grind Rail null: " + str(name) + " at " + str(global_position)))


func body_entered(body: Player) -> void:
	remote.remote_path = body.get_path()
	body.inZipline = true

func body_exit(body: Player) -> void:
	body.inZipline = false
