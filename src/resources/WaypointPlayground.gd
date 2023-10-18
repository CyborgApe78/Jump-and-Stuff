extends WaypointSystem
class_name WaypointPlayground

enum list {
	Null,
	Starting,
	Platforms,
	Doors,
}


func add_waypoint(name: String, location: Vector2) -> void:
	locations[name] = location
