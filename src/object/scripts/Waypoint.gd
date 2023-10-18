extends SavePoint

@export var waypointName: WaypointPlayground.list

func _ready() -> void:
	super._ready()
	body_entered.connect(_on_waypoint_entered)
	
	if waypointName == WaypointPlayground.list.Starting:
		WaypointSystem.add_waypoint("Starting", global_position)
	elif waypointName == WaypointPlayground.list.Platforms:
		WaypointSystem.add_waypoint("Platforms", global_position)


func _on_waypoint_entered(body) -> void:
#	if waypointName == WaypointPlayground.list.Starting and WaypointPlayground.unlockedStarting != true:
#		WaypointSystem.unlockedUp = true
#	elif waypointName == WaypointPlayground.list.Platforms and WaypointPlayground.unlockedPlatforms != true:
#		WaypointSystem.unlockedDown = true
	pass

