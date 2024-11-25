class_name MachineState extends Node

signal entered
signal finished(next_state: MachineState)

var FSM: FiniteStateMachine

@export var transformTime: float = 0.2

@export_group("Connections")
@export var player: Player
@export var inputs: InputManager
@export var characterRig: CharacterRig
@export var stats: StatsManager
@export var velocity: VelocityManager


func ready() -> void:
	pass


func enter() -> void:
	pass


func exit(_next_state: MachineState) -> void:
	pass


func handle_input(_event: InputEvent):
	pass


func physics_update(_delta: float):
	pass


func state_update(_delta: float):
	pass


func visual_update(_delta: float):
	pass


func sound_update(_delta: float):
	pass
