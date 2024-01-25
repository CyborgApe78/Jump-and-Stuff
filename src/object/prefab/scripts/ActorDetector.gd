extends Area2D
class_name ActorDetector

#TODO: make seperate trigger scene, with animation

@export var playerDetect: bool = true
@export var enemyDetect: bool = true

signal triggerd #FIXME: typo

func _ready() -> void:
	set_collision_mask_value(1, false)
	set_collision_layer_value(1, false)
	
	if playerDetect:
		set_collision_mask_value(CollisionLayers.Player, true)
	if enemyDetect:
		set_collision_mask_value(CollisionLayers.Enemy, true)


func _on_body_entered(body: Node2D) -> void:
	triggerd.emit()
