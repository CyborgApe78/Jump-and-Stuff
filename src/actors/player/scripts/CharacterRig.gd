extends Node2D


@export var characterCollision: CollisionShape2D


var transformTime: float = 0.2


func to_walk() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(self, "position", Vector2(0,-32), transformTime).from_current()
	tween.tween_property(self, "scale", Vector2(0.5, 0.5), transformTime).from_current()

func to_slide() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(self, "position", Vector2(0,-16), transformTime).from_current()
	tween.tween_property(self, "scale", Vector2(1,0.25), transformTime).from_current()

func to_crouch() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(self, "scale", Vector2(scale.x, 0.5), transformTime).from_current()
	
	characterCollision.shape.height = 48
	characterCollision.shape.radius = 32
	characterCollision.position.y = -24


func from_crouch() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(self, "scale", Vector2(scale.x, 1), transformTime).from_current()
	
	characterCollision.shape.height = 96
	characterCollision.shape.radius = 32
	characterCollision.position.y = -48
