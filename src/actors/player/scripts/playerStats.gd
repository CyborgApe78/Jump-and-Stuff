extends Resource
class_name PlayerStats

var healthMax: int = 4:
	set(v):
		if healthMax != 0:
			EventBus.playerStatChange.emit(list.HealthMax, v)
		healthMax += v
		healthMax = max(0, healthMax)

var health: int = 3

var baseSpeed: int = 25:
	set(v):
		if baseSpeed != 0:
			EventBus.playerStatChange.emit(list.MoveSpeed, v)
		baseSpeed += v
		baseSpeed = max(0, baseSpeed)

var baseAcceleration: float = 1.2
var baseFriction: float = 1.0
var airModifier: float = 1.2

var baseJumpHeight: float = 4.25:
	set(v):
		if baseJumpHeight != 0:
			EventBus.playerStatChange.emit(list.JumpHeight, v)
		baseJumpHeight += v
		baseJumpHeight = max(0, baseJumpHeight)

var terminalVelocityModifier: float = 2

var energyMax: float = 4.25:
	set(v):
		if energyMax != 0:
			EventBus.playerStatChange.emit(list.EnergyMax, v)
		EventBus.playerStatChange.emit(list.EnergyMax, v)
		energyMax += v

enum list{
	HealthMax,
	MoveSpeed,
	JumpHeight,
	EnergyMax,
}
