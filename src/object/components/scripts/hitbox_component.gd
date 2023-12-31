extends Area2D
class_name HitboxComponent

@export var health: HealthComponent

signal damaged

func _ready() -> void:
	#if !health:
		#EventBus.error.emit(str(owner) + " missing health component")
	pass

func damage(amount: Attack) -> void:
	if health:
		health.damage(amount)
		set_deferred("monitorable", false)
	else:
		damaged.emit()
	#FIXME: not working, suppose to make it so the player gets hurt on the same spikes after timer


func heal(amount: Heal) -> void:
	if health:
		health.heal(amount)


func _on_invincibility_timeout() -> void:
	set_deferred("monitorable", true)
