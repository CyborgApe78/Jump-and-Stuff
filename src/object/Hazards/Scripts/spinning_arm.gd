extends StaticHazard


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
var currentSpeed: int

func _ready() -> void:
	super._ready()
	set_length()


func _physics_process(delta: float) -> void:
	if not timeFreeze:
		arm.rotate(speed * delta)


func set_length() -> void:
	#hurtboxCollision.position.x = length / 2
	#hurtboxCollision.shape.size.x = length
	pass
