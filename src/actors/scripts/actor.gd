extends CharacterBody2D
class_name Actor

@export var healthMax: int = 4

var inWind: bool = false
var inWater: bool = false
var windVelocity: Vector2 = Vector2.ZERO

var health: int :
	set(v):
		health = clamp(v, 0, healthMax)
#		EventBus.emit_signal("playerHea")
