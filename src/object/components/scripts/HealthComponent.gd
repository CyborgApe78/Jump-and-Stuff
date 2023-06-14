extends Node
class_name HealthComponent

signal died
signal  healthChanged(amount)

#TODO: invincitbility timer

@export var healthMax: int = 1
@export var invicibleTime: float = 1.0
@export var stats: Resource
@onready var invicibleTimer: Timer = $Invincability

var healthCurrent: int:
	set(v):
		healthChanged.emit(v)
		healthCurrent = clamp(v, 0, healthMax)
		if v == 0:
			died.emit()
			


func  _ready() -> void:
	invicibleTimer.wait_time = invicibleTime
	if stats != null:
		healthMax = stats.healthMax
		
	healthCurrent = healthMax #LOOKAT: might heal unexpectedly


func damage(amount: int) -> void:
	if invicibleTimer.is_stopped():
		invicibleTimer.start()
		healthCurrent -= amount


func heal(amount:int) -> void:
	pass
