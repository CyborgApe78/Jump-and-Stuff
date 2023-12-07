extends RayCast2D


#TODO: rotate with character
#TODO: move this over to Enviroment detector

func _ready() -> void:
	set_collision_mask_value(CollisionLayers.FLUID, true)
