extends Area2D
class_name HurtBox

#TODO: figure out a way to auto connect collision shape

@export var damage: int = 1
@export var isBurning: bool = false
@export var isFreezing: bool = false
@export var oneUse: bool = false
@export var kill: bool = false
@export var noDamage: bool = false #TODO: better name #TODO: setup last safe ground, like red spikes in Lone Fungus 


func _ready() -> void:
	set_collision_mask_value(CollisionLayers.Hazard, true)


func _on_area_entered(area: HitboxComponent) -> void:
	var attack = Attack.new()
	
	if kill:
		attack.damage = 99
	else:
		attack.damage = damage
	attack.isBurning = isBurning
	attack.isFreezing = isFreezing
	
	area.damage(attack)
	
	if oneUse:
		queue_free()
