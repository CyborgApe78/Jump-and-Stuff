extends Area2D
class_name ActorDetector


@export var playerDetect: bool = true
@export var enemyDetect: bool = true

signal triggerd

func _ready() -> void:
	if playerDetect:
		set_collision_mask_value(CollisionLayers.Player, true)
	if enemyDetect:
		set_collision_mask_value(CollisionLayers.Enemy, true)

func _on_body_entered(body: Node2D) -> void:
	triggerd.emit()
