extends Resource
class_name PlayerStats

var healthMax: int = 4
var health: int = 3

var baseSpeed: int = 25
var turboSpeed #min speed for wall run  #TODO: make based off base speed
var baseAcceleration: float = 1.2
var baseFriction: float = 1.0
var airModifier: float = 0.8

var baseJumpHeight: float = 6.25
