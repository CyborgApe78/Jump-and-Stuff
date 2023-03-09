@tool
extends Node2D


@export var characterCollision: CollisionShape2D
@export var charPoly: Polygon2D
@export var charLine: Line2D


var transformTime: float = 0.2


@onready var head: Node2D = $CharacterRotate/Head
@onready var eye: Node2D = $CharacterRotate/Eye

@export var headRadius: int = 28
@export var eyeRadius: int = 2
@export var eyeOffset: int = 2


func _process(delta) -> void:
	queue_redraw()


func _draw() -> void:
	draw_circle(head.position, headRadius * 1.1, Color.BLACK)
	draw_circle(head.position, headRadius, Color.PURPLE)
	draw_circle(eye.position, eyeRadius * 3, Color.BLACK)
	draw_circle(eye.position + Vector2(eyeOffset,-eyeOffset), eyeRadius, Color.WHITE)

func to_walk() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(self, "position", Vector2(0,-32), transformTime).from_current()
	tween.tween_property(self, "scale", Vector2(1, 1), transformTime).from_current()

func to_slide() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(self, "scale", Vector2(2, 0.5), transformTime).from_current()
#	tween.tween_property(charPoly, "position", Vector2(0,20), transformTime).from_current()
#	tween.tween_property(charPoly, "scale", Vector2(2,0.25), transformTime).from_current()
#	tween.tween_property(charLine, "position", Vector2(32,20), transformTime).from_current()
#	tween.tween_property(charLine, "scale", Vector2(2,0.5), transformTime).from_current()


func from_slide() -> void:
	#TODO: in animplayer, don't need to reset positions once all anims made
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1, 1), transformTime).from_current()
#	tween.tween_property(charPoly, "position", Vector2(0,0), transformTime).from_current()
#	tween.tween_property(charPoly, "scale", Vector2(1,1), transformTime).from_current()
#	tween.tween_property(charLine, "position", Vector2(16,0), transformTime).from_current()
#	tween.tween_property(charLine, "scale", Vector2(1,1), transformTime).from_current()



func to_crouch() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(self, "scale", Vector2(scale.x, 0.5), transformTime).from_current()


func from_crouch() -> void:
#	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
#	tween.tween_property(self, "scale", Vector2(scale.x, 1), transformTime).from_current()
	pass
