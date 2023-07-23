extends AbilityBlockBase

@onready var raycastBoost: RayCast2D = $RayCast2D
@export var rotateBlock: bool = false
var boostDirection: Vector2
@export var boostAmount: int = 5



func _ready() -> void:
	super._ready()
	body_entered.connect(boost)
	if ability == PlayerAbilities.list.All:
		set_collision_mask_value(CollisionLayers.Player, true)
	elif ability == PlayerAbilities.list.DashSide:
		set_collision_mask_value(CollisionLayers.DashSide, true)
	elif ability == PlayerAbilities.list.DashUp:
		set_collision_mask_value(CollisionLayers.DashUp, true)
	elif ability == PlayerAbilities.list.DashDown:
		set_collision_mask_value(CollisionLayers.DashDown, true)
#	elif ability == PlayerAbilities.list.HookShot:
#		set_collision_mask_value(CollisionLayers.HookShot, true)
	elif ability == PlayerAbilities.list.Burrow:
		set_collision_mask_value(CollisionLayers.Burrow, true)
	elif ability == PlayerAbilities.list.SwimDash:
		set_collision_mask_value(CollisionLayers.SwimDash, true)
	else:
		EventBus.error.emit("Ability Reset error for " + str(ability) +" at: " + str(name) + " at " + str(global_position))



func _physics_process(delta: float) -> void:
	if rotateBlock:
		rotate(.1)

func boost(body) -> void:
	var rGlobalOrigin = raycastBoost.to_global(Vector2.ZERO)
	var rGlobalCastToEndpoint = raycastBoost.to_global(raycastBoost.target_position)
	boostDirection = rGlobalCastToEndpoint - rGlobalOrigin
	boostDirection.x = signi(boostDirection.x)
	boostDirection.y = signi(boostDirection.y)
	body.velocity = boostDirection * (boostAmount * Util.tileSize)
