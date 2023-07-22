extends AbilityBlockBase
#TODO: connected destruction, probaly own block

@onready var staticBodyCollision: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var collisionShape: CollisionShape2D = $CollisionShape2D
@onready var  staticBody: StaticBody2D = $StaticBody2D


func _ready() -> void:
	super._ready()
	staticBodyCollision.shape = collisionShape.shape
	staticBodyCollision.shape.extents.x = collisionShape.shape.extents.x
	staticBodyCollision.shape.extents.y = collisionShape.shape.extents.y
	
	if ability == PlayerAbilities.list.DashSide:
		staticBody.set_collision_layer_value(CollisionLayers.DashSide, true)
	elif ability == PlayerAbilities.list.DashUp:
		staticBody.set_collision_layer_value(CollisionLayers.DashUp, true)
	elif ability == PlayerAbilities.list.DashDown:
		staticBody.set_collision_layer_value(CollisionLayers.DashDown, true)
#	elif ability == PlayerAbilities.list.HookShot:
#		staticBody.set_collision_layer_bit(CollisionLayers.HookShot, true)
	elif ability == PlayerAbilities.list.Burrow:
		staticBody.set_collision_layer_value(CollisionLayers.Burrow, true)
	elif ability == PlayerAbilities.list.SwimDash:
		staticBody.set_collision_layer_value(CollisionLayers.SwimDash, true)
	else:
		EventBus.error.emit("Ability Wall error for " + str(ability) +" at: "  + str(name) + " at " + str(global_position))

