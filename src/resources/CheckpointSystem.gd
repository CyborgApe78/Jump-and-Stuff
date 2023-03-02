extends Resource
class_name CheckpointSystem


var currentRespawn: Vector2 = Vector2.ZERO
var startingArea: Vector2 = Vector2.ZERO
var lastSafeGround: Vector2 = Vector2.ZERO
var lastCheckpoint: Vector2 = Vector2.ZERO


func set_checkpoint(location) -> void:
	lastCheckpoint = currentRespawn
	currentRespawn = location

func reset_checkpoint() -> void:
	currentRespawn = startingArea
	print("work")


func get_respawn() -> Vector2:
	if currentRespawn != Vector2.ZERO:
		return currentRespawn
		
	return startingArea
