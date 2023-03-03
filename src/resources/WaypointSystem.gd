extends Resource
class_name WaypointSystem


var unlockedUp: bool = false
var unlockedDown: bool = false

enum list {
	Null,
	Up,
	Down,
}

var locations: Dictionary = {}


func add_waypoint(name: String, location: Vector2) -> void:
	locations[name] = location
