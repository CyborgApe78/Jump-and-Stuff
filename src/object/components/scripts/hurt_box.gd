extends Area2D
class_name HurtBox


@export var damage: int = 1
@export var isBurning: bool = false
@export var isFreezing: bool = false
@export var oneUse: bool = false


func _on_area_entered(area: Hitbox) -> void:
	var attack = Attack.new()
	
	attack.damage = damage
	attack.isBurning = isBurning
	attack.isFreezing = isFreezing
	
	area.damage(attack)
	
	if oneUse:
		queue_free()
