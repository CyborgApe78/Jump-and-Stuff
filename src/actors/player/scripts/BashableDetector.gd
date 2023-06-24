extends Area2D


#TODO: raycast to find closest

@export var indicatorTarget: Line2D

var target: TargetBash


func _ready() -> void:
	set_collision_mask_value(CollisionLayers.Bash, true) #LOOKAT: convert these to a target layer and use class_name to tell what it is
	indicatorTarget.default_color = AbilityColor.bashColor #LOOKATL change to the draw being on the object, only update on signals and nor running all the time


func _physics_process(delta: float) -> void:
	if target != null:
		indicatorTarget.global_position = target.global_position


func _on_area_entered(area: TargetBash) -> void:
	target = area
	indicatorTarget.visible = true 


func _on_area_exited(area: TargetBash) -> void:
	target = null
	indicatorTarget.visible = false 
