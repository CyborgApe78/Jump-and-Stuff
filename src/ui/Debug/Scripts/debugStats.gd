extends Control


@export var amountHealth: OptionButton
@export var amountEnergy: OptionButton
@export var amountMoveSpeed: OptionButton
@export var amountJumpHeight: OptionButton

var Stats: Resource = preload("res://src/actors/player/resources/playerStats.tres")


func _ready() -> void:
	EventBus.debugMenuOpened.connect(check)


func check(BOOL) -> void:
	amountHealth.selected = Stats.healthMax - 1
	amountEnergy.selected = Stats.energyMax - 1
#	amountMoveSpeed.selected = Stats.moveSpeed - 1 #TODO:
	amountJumpHeight.selected = Stats.baseJumpHeight - 1.25


func _on_health_amount_selected(index: int) -> void:
	Stats.healthMax = index + 1


func _on_energy_amount_selected(index: int) -> void:
	Stats.energyMax = index + 1


func _on_moveSpeed_amount_selected(index: int) -> void:
	Stats.moveSpeed = index + 1


func _on_jumpHeight_amount_selected(index: int) -> void:
	Stats.jumpHeight = index + 1
