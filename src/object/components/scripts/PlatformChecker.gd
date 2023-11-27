extends Area2D
class_name PlatformCheckerComponent

## Area for platforms to check instead of looking at the whole collision shape


@onready var parent: Actor = get_parent()

@export var collision: CollisionShape2D


func _ready() -> void:
	set_collision_layer_value(CollisionLayers.Player, parent.get_collision_layer_value(CollisionLayers.Player))
	set_collision_layer_value(CollisionLayers.Enemies, parent.get_collision_layer_value(CollisionLayers.Enemies))

func _physics_process(delta: float) -> void:
	if parent.velocity.y == 0 and parent.is_on_floor():
		if collision.disabled:
			collision.disabled = false
	else:
		if !collision.disabled:
			collision.disabled = true
