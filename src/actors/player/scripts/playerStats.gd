extends Resource
class_name PlayerStats


var healthMax: int = 2:
	set(v):
		healthMax = v
		healthMax = max(1, healthMax)

var baseSpeed: int = 25:
	set(v):
		baseSpeed += v
		baseSpeed = max(0, baseSpeed)

var baseJumpHeight: float = 8:
	set(v):
		baseJumpHeight += v + 0.25
		baseJumpHeight = max(0, baseJumpHeight)


var energyMax: float = 1:
	set(v):
		energyMax += v
		energyMax = max(0, energyMax)

var baseAcceleration: float = 1.2
var baseFriction: float = 0.5
var airModifier: float = 1.2
var terminalVelocityModifier: float = 2

enum list{
	HealthMax,
	MoveSpeed,
	JumpHeight,
	EnergyMax,
}

func change(stat, amount) -> void:
	if stat == list.HealthMax:
		healthMax += amount
	if stat == list.MoveSpeed:
		baseSpeed += amount
	if stat == list.JumpHeight:
		baseJumpHeight += amount
	if stat == list.EnergyMax:
		energyMax += amount
	
