extends AbilityBlockBase

#TODO: make it work
#TODO can hurt player after respawn, need invincability timer
@export var detectorCollision: CollisionShape2D = $Area2D/CollisionShape2D
@export var collisionShape: CollisionShape2D = $CollisionShape2D
@export var  abilityDetector: Area2D = $Area2D

var playerInHazard: bool = false
var correctAbility: bool = false
var damageAmount: int = 1
#
#func _ready() -> void:
#	detectorCollision.shape = collisionShape.shape
#	detectorCollision.shape.extents.x = collisionShape.shape.extents.x
#	detectorCollision.shape.extents.y = collisionShape.shape.extents.y
#
#	body_entered.connect(_on_hazard_entered)
#	body_exited.connect(_on_hazard_exited)
#	connect("area_entered", self, "_on_player_entered")
#	connect("area_exited", self, "_on_player_exited")
#	if ability == PlayerAbilities.list.All:
#		abilityDetector.set_collision_mask_value(CollisionLayers.Interactable, true)
#	elif ability == PlayerAbilities.list.DashSide:
#		abilityDetector.set_collision_mask_value(CollisionLayers.DashSide, true)
#	elif ability == PlayerAbilities.list.DashUp:
#		abilityDetector.set_collision_mask_value(CollisionLayers.DashUp, true)
#	elif ability == PlayerAbilities.list.DashDown:
#		abilityDetector.set_collision_mask_value(CollisionLayers.DashDown, true)
##	elif ability == PlayerAbilities.list.HookShot:
##		abilityDetector.set_collision_mask_value(CollisionLayers.HookShot, true)
#	elif ability == PlayerAbilities.list.Burrow:
#		abilityDetector.set_collision_mask_value(CollisionLayers.Burrow, true)
#	elif ability == PlayerAbilities.list.SwimDash:
#		abilityDetector.set_collision_mask_value(CollisionLayers.SwimDash, true)
#	else:
#		EventBus.emit_signal("error", "Ability Boost error for " + str(ability) +" at: "  + str(name) + " at " + str(global_position))
#
#func _physics_process(delta: float) -> void:
#	if playerInHazard and !correctAbility:
#		EventBus.emit_signal("playerHealthChanged", -damageAmount)
#
#func _on_player_entered(area: Hitbox) -> void:
#	playerInHazard = true
#
#func _on_player_exited (area: Hitbox) -> void:
#	playerInHazard = false
#
#func _on_hazard_entered(body: Player) -> void:
#	correctAbility = true
#
#func _on_hazard_exited(body: Player) -> void:
#	correctAbility = false
