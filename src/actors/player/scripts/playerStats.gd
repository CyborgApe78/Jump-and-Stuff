extends Resource
class_name PlayerStats


var healthMax: int = 4
var health: int = 3

var baseSpeed: int = 25
var baseAcceleration: float = 1.2
var baseFriction: float = 1.0
var airModifier: float = 1.2

var baseJumpHeight: float = 4.25
var terminalVelocityModifier: float = 2

enum list{
	HealthMax,
	MoveSpeed,
	JumpHeight,
}
