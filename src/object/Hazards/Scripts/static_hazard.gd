extends StaticBody2D
class_name StaticHazard


var timeFreeze: bool = false


func _ready() -> void:
	EventBus.timeFreeze.connect(freeze_time)


func freeze_time(v: bool) -> void:
	timeFreeze = v
