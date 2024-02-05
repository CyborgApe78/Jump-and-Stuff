extends Node2D
class_name SpikeGroup

#LOOKAT: turn into generic shake

@export var spike1: Line2D

@export var length: int = 48

var pos1: Vector2
var pos2: Vector2

func  _ready() -> void:
	pos1 = spike1.get_point_position(1)
	pos2 = spike1.get_point_position(2)

#region Shake
func shake(duration: float) -> void:
	for spike: Line2D in get_children():
		_random_movement(spike, duration)


func _random_movement(node: Node, duration: float) -> void:
	var starPos: Vector2 = node.position
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "position", new_position(starPos), duration / 3).from_current()
	tween.tween_property(node, "position", new_position(starPos), duration / 3).from_current()
	tween.tween_property(node, "position", starPos, duration / 3).from_current()


func new_position(pos: Vector2) -> Vector2:
	var newX: int
	var newY: int
	
	newX = pos.x + randi_range(-2, 2)
	newY = pos.y + randi_range(-2, 2)
	
	return Vector2(newX, newY)


#endregion


#region Move
func extend(duration: float) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_method(update_point1, spike1.points[1], spike1.points[1] + Vector2(0, -length/2), (duration * 1.2))
	tween.tween_method(update_point2, spike1.points[2], spike1.points[2] + Vector2(0, -length), duration)


func retract(duration: float) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_method(update_point1, spike1.points[1], spike1.points[1] - Vector2(0, -length/2), (duration * 0.8))
	tween.tween_method(update_point2, spike1.points[2], spike1.points[2] - Vector2(0, -length), duration)

func update_point1(newPosition: Vector2):
	for spike: Line2D in get_children():
		spike.set_point_position(1, newPosition)


func update_point2(newPosition: Vector2):
	for spike: Line2D in get_children():
		spike.set_point_position(2, newPosition)
#endregion
