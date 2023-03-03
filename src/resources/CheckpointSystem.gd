extends Resource
class_name CheckpointSystem
#FIXME: breeks if checkpoint is at 0,0

var currentRespawn: Vector2 = Vector2.ZERO
var startingArea: Vector2 = Vector2.ZERO
var lastSafeGround: Vector2 = Vector2.ZERO
var lastCheckpoint: Vector2 = Vector2.ZERO


func set_checkpoint(location) -> void:
	lastCheckpoint = currentRespawn
	currentRespawn = location


func reset_checkpoint() -> void:
	currentRespawn = startingArea
	#TODO: Waypoint logic added


func get_respawn() -> Vector2:
	if currentRespawn != Vector2.ZERO:
		return currentRespawn
		
	return startingArea
