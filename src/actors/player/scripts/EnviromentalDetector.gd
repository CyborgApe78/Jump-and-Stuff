extends Area2D
class_name EnviromentalDetector


func _ready() -> void:
	set_collision_mask_value(CollisionLayers.Enviromental, true)


func _on_area_entered(area: Enviromental) -> void:
	if area is GrindRail:
		print("Grind me")
	elif area is Climbable:
		print("Climb me")
	elif area is Wind:
		print("Blow me")
	elif area is Water:
		print("Water me")
	#elif area == WallRun:
		#pass


func _on_area_exited(area: Enviromental) -> void:
	if area is GrindRail:
		print("Don't Grind me")
	elif area is Climbable:
		print("Don't Climb me")
	elif area is Wind:
		print("Don't Blow me")
	elif area is Water:
		print("Don't Water me")
