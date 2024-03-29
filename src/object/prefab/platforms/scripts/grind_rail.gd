extends Path2D

#TODO: look into combining base class with climbable
#FIXME: need to figure how to move path follow to players position

@export var rail: Line2D
@export var detector: Area2D
@export var collision: CollisionPolygon2D
@export var pathFollow: PathFollow2D
@export var remote: RemoteTransform2D
@export var remoteRec: ColorRect


func _ready() -> void:
	if OS.has_feature("editor"):
		remoteRec.visible = true
	rail.default_color = GameColor.RailColor
	if curve != null:
		rail.points = curve.get_baked_points()
		await get_tree().process_frame
		var line_poly = Geometry2D.offset_polyline(rail.points, rail.width / 2, Geometry2D.JOIN_ROUND, Geometry2D.END_ROUND)
		for poly in line_poly:
			collision.polygon = poly
	else:
		EventBus.error.emit(str("Grind Rail null: " + str(name) + " at " + str(global_position)))


func body_entered(body: Player) -> void:
	remote.remote_path = body.get_path()
	body.grindRail = self
	body.grindRailFollow = pathFollow
	body.inRail = true #TODO: change to signal like trapeze


func body_exit(body: Player) -> void:
	remote.remote_path = NodePath("")
	body.inRail = false
	#TODO: need to null body.grindRail 

