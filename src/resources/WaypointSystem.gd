extends Resource
class_name WaypointSystem


var locations: Dictionary = {}


func add_waypoint(name: String, location: Vector2) -> void:
	locations[name] = location
