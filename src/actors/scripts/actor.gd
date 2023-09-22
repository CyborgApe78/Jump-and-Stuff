extends CharacterBody2D
class_name Actor

signal enterWater

var inWind: bool = false #TODO: make components
var inWater: bool = false:
	set(value):
		inWater = value
		enterWater.emit()
var windVelocity: Vector2 = Vector2.ZERO

