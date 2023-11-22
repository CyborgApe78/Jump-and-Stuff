extends CharacterBody2D
class_name Actor

signal enterWater
signal enterZipline

var inWind: bool = false #TODO: make components
var inWater: bool = false:
	set(value):
		inWater = value
		enterWater.emit()
var inZipline: bool = false:
	set(v):
		inZipline = v
		if v == true:
			enterZipline.emit()
var windVelocity: Vector2 = Vector2.ZERO

