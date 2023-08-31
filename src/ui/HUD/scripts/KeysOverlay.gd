extends MarginContainer


@export var labelKeys: Label
@export var timer: Timer
@export var labels: HBoxContainer

@export var time: float = 3

var inventory: Resource = preload("res://src/actors/player/resources/Inventory.tres")


func _ready() -> void:
	timer.wait_time = time
	update_keys()
	EventBus.checkKeys.connect(update_keys)
	EventBus.showKeys.connect(show_keys)
	show_keys()


func show_keys() -> void:
	labels.visible = true
	timer.start()


func update_keys() -> void:
	labelKeys.text = str(inventory.keys)


func _on_timer_timeout() -> void:
	labels.visible = false
