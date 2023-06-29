extends Node

var settings: Resource = preload("res://src/resources/SettingsConfig.tres")


func _ready() -> void:
	EventBus.rumble.connect(rumble)


func rumble(low:float, high: float, duration: float) -> void:
	if settings.rumble:
		Input.start_joy_vibration(0, low, high, duration)
