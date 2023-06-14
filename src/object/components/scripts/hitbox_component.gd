extends Area2D
class_name Hitbox

@export var health: HealthComponent


func  _ready() -> void:
	if !health:
		EventBus.error.emit(str(owner) + " missing health component")

func damage(amount: Attack) -> void:
	if health:
		health.damage(amount)

func heal(amount: Heal) -> void:
	if health:
		health.heal(amount)
