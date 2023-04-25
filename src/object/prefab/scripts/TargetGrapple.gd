extends Interactable
class_name TargetGrapple


func _ready() -> void:
	super._ready()
	modulate = AbilityColor.grappleColor
	set_collision_layer_value(CollisionLayers.GrappleHook, true)
