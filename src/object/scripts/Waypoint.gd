extends SavePoint

@export var waypointName: WaypointSystem.list

func _ready() -> void:
	super._ready()
	body_entered.connect(_on_waypoint_entered)
	
	if waypointName == WaypointSystem.list.Up:
		WaypointSystem.add_waypoint("Up", global_position)
	elif waypointName == WaypointSystem.list.Down:
		WaypointSystem.add_waypoint("Down", global_position)


func _on_waypoint_entered(body) -> void:
	if waypointName == WaypointSystem.list.Up and WaypointSystem.unlockedUp != true:
		WaypointSystem.unlockedUp = true
	elif waypointName == WaypointSystem.list.Down and WaypointSystem.unlockedDown != true:
		WaypointSystem.unlockedDown = true


