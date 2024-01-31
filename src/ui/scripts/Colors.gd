@tool
extends VBoxContainer

#TODO: figure out a good way to select colors

@export_category("Connections")
@export var bashLabel: Label
@export var burrowLabel: Label
@export var climbLabel: Label
@export var dashLabel: Label
@export var grappleLabel: Label
@export var groundLabel: Label
@export var hazardLabel: Label
@export var railLabel: Label
@export var usedLabel: Label


func _ready() -> void:
	bashLabel.modulate = GameColor.bashColor
	burrowLabel.modulate = GameColor.burrowColor
	climbLabel.modulate = GameColor.climbColor
	dashLabel.modulate = GameColor.dashSideColor
	grappleLabel.modulate = GameColor.grappleColor
	groundLabel.modulate = GameColor.ground
	hazardLabel.modulate = GameColor.HAZARD
	railLabel.modulate = GameColor.RailColor
	usedLabel.modulate = GameColor.abilityUsedColor
