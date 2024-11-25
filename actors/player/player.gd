class_name Player extends CharacterBody2D


@export var characterRig: Node2D

var facing: int = -1


func _physics_process(_delta: float) -> void:
	move_and_slide()


func facing_logic(direction: int):
	if direction != 0 and characterRig.scale.x != direction:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(characterRig, "scale", Vector2(direction, characterRig.scale.y), 0.4).from_current()
		facing = direction
