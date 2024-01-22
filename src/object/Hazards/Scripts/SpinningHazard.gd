extends StaticHazard

#TODO: make length change in editor
#FIXME: create ysort layers, have walls be lower than the hazarad boxes

@export_group("Connections")
@export var hurtbox: HurtBox
@export var hurtboxCollision: CollisionShape2D

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
	super._ready()
	set_length()
	


func _physics_process(delta: float) -> void:
	if not timeFreeze:
		hurtbox.rotate(speed * delta)
	


func set_length() -> void:
	hurtboxCollision.position.x = length / 2
	hurtboxCollision.shape.size.x = length


