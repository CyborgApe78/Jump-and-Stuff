extends Node
class_name HealthComponent

#FIXME: rework interaction of hitbox and health component to simplify

signal died
signal healthChanged(amount)


var healthMax: int
@export var invicibleTime: float = 1.0
@export var invicibleTimer: Timer

var stats: Resource = preload("res://src/actors/player/resources/playerStats.tres")


var healthCurrent: int:
	set(v):
		healthCurrent = clamp(v, 0, healthMax)
		EventBus.playerHealthChanged.emit(healthCurrent)
		if v == 0:
			died.emit()


func _ready() -> void:
	invicibleTimer.wait_time = invicibleTime
	if stats != null:
		healthMax = stats.healthMax
		
	healthCurrent = healthMax #LOOKAT: might heal unexpectedly
	
	EventBus.playerStatsCheck.connect(set_health_max)


func set_health_max() -> void:
	healthMax = stats.healthMax


func damage(attack: Attack) -> void:
	if invicibleTimer.is_stopped():
		invicibleTimer.start() 
		healthCurrent -= attack.damage



func heal(amount: Heal) -> void:
	healthCurrent += amount.amount
