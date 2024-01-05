extends StaticBody2D

#TODO: make length change in editor
#TODO: make length work
#TODO: add more arms
#TODO: hazard radius

@export_group("Connections")
@export var arm: Line2D

@export_group("")
@export var speed: int = 2
@export var _baseLength: int = 3:
	set(v):
		_baseLength = v
		length = v * Util.tileSize
		set_length()
	get:
		return _baseLength

var length: int = _baseLength * Util.tileSize


func _ready() -> void:
	set_length()


func _physics_process(delta: float) -> void:
	arm.rotate(speed * delta)


func set_length() -> void:
	#hurtboxCollision.position.x = length / 2
	#hurtboxCollision.shape.size.x = length
	pass
