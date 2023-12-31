@tool
extends StaticBody2D

#TODO: add length to export

@export_group("Connections")
@export var hurtbox: HurtBox
@export var hurtboxCollision: CollisionShape2D

@export_group("")
@export var speed: int = 2
@export var _baseLength: int = 3:
	set(v):
		_baseLength = v
		length = v * Util.tileSize
	get:
		return _baseLength

var length: int = _baseLength * Util.tileSize


func _ready() -> void:
	set_length()


func _physics_process(delta: float) -> void:
	hurtbox.rotate(speed * delta)


func set_length() -> void:
	hurtboxCollision.position.x = length / 2
	hurtboxCollision.shape.size.x = length
