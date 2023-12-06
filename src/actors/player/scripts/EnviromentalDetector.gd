extends Area2D
class_name EnviromentalDetector


func _ready() -> void:
	set_collision_mask_value(CollisionLayers.Enviromental, true)


func _on_area_entered(area: Enviromental) -> void:
	if area is GrindRail:
		pass
	elif area is Climbable:
		pass
	elif area is Wind:
		pass
	elif area is Water:
		pass
	#elif area == WallRun:
		#pass


func _on_area_exited(area: Enviromental) -> void:
	if area is GrindRail:
		pass
	elif area is Climbable:
		pass
	elif area is Wind:
		pass
	elif area is Water:
		pass
