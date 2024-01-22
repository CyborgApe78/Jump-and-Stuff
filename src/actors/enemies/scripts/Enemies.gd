extends Actor
class_name Enemies


@export var rig: Node2D


func facing_logic(direction: int): #TODO: add to global
	if direction != 0 and rig.scale.x != direction:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(rig, "scale", Vector2(direction, rig.scale.y), 0.4).from_current()
