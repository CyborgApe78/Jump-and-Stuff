extends Resource
class_name PlayerStats

#TODO: update PlayerInfo with new stats

var healthMax: int = 4:
	set(v):
		if healthMax != 0:
			EventBus.playerStatChange.emit(list.HealthMax, v)
		healthMax += v
		healthMax = max(0, healthMax)

var baseSpeed: int = 25:
	set(v):
		if baseSpeed != 0:
			EventBus.playerStatChange.emit(list.MoveSpeed, v)
		baseSpeed += v
		baseSpeed = max(0, baseSpeed)

var baseJumpHeight: float = 4.25: #TODO: add .25 to any change
	set(v):
		if baseJumpHeight != 0:
			EventBus.playerStatChange.emit(list.JumpHeight, v)
		baseJumpHeight += v + 0.25
		baseJumpHeight = max(0, baseJumpHeight)


var energyMax: float = 1:
	set(v):
		if energyMax != 0:
			EventBus.playerStatChange.emit(list.EnergyMax, v)
		EventBus.playerStatChange.emit(list.EnergyMax, v)
		energyMax += v

#TODO: move things that won't change to playerInfo
var baseAcceleration: float = 1.2
var baseFriction: float = 1.0
var airModifier: float = 1.2
var terminalVelocityModifier: float = 2

enum list{
	HealthMax,
	MoveSpeed,
	JumpHeight,
	EnergyMax,
}
