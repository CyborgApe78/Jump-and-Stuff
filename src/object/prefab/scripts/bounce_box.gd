extends Area2D

#TODO: normal spring, bumper, bounce after jumping, launch barrel

@onready var bounceStrength: int = _strength * Util.tileSize
@onready var bounceVelocity: Vector2 = Vector2(0,-bounceStrength).rotated(rotation)

@export_range(1, 10, 1) var _strength: int = 2:
	set(v):
		bounceStrength = v * Util.tileSize
		bounceVelocity = Vector2(0,-bounceStrength).rotated(rotation)
		_strength = v

@export var rotate: bool = false
@export var rotationSpeed: float = 0.1 #TODO: figure out range

@export_category("Connections")
@export var indicator: Node2D


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if rotate:
		indicator.rotate(rotationSpeed)


func _on_body_entered(body: Actor) -> void:
	body.velocity = bounceVelocity
