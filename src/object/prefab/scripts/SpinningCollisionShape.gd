extends VisibleCollisionShape2D

#TODO: make direction indicator

@export var speed: int = 200


func _physics_process(delta: float) -> void:
	rotate(speed * delta)
