extends Interactable
class_name TargetGrapple


func _ready() -> void:
	super._ready()
	modulate = GameColor.grappleColor
	set_collision_layer_value(CollisionLayers.GrappleHook, true)
