extends Area2D
class_name HealBox


@export var amount: int = 1
@export var duration: float = 0.0
@export var oneUse: bool = false


func _on_area_entered(area: Hitbox) -> void:
	print("heal me")
	var heal = Heal.new()
	
	heal.amount = amount
	heal.duration = duration
	
	area.heal(heal)
	
	if oneUse:
		queue_free()
