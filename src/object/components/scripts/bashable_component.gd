extends Area2D #LOOKAT: inherit from interactable?
class_name TargetBash


func _ready() -> void:
	set_collision_layer_value(CollisionLayers.Bash, true)
