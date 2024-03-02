extends AnimatableBody2D
class_name AnimatablePlatform


var timeFreeze: bool = false

#TODO: use this to detect actors 
	## var collider: = kc.get_collider()
	## if collider is Player && collider.is_on_floor():

func _ready() -> void:
	EventBus.timeFreeze.connect(freeze_time)


func freeze_time(v: bool) -> void:
	timeFreeze = v
