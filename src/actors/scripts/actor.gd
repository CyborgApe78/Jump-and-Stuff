extends CharacterBody2D
class_name Actor


signal enterWater
signal enterRail

var inWind: bool = false #TODO: make components
var inWater: bool = false:
	set(value):
		inWater = value
		enterWater.emit()
var inRail: bool = false: #TODO: make signal
	set(v):
		inRail = v
		if v == true:
			enterRail.emit()
var windVelocity: Vector2 = Vector2.ZERO
var grindRail: Path2D
var grindRailFollow: PathFollow2D
var trapeze: Area2D
