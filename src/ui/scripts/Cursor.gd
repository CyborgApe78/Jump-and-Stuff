extends Panel
class_name Cursor

#FIXME: called twice by first button

@export var margin: int = 20


func on_focused(gPosition: Vector2, lPosition: Vector2, size: Vector2) -> void:
	if visible != true:
		size = Vector2(size.x + margin, size.y + margin)
		global_position = Vector2(gPosition.x - (margin / 2), gPosition.y - (margin / 2))
		visible = true
		#print("see me")
	else:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
		tween.tween_property(self, "size", Vector2(size.x + margin, size.y + margin), 0.2).from_current()
		tween.tween_property(self, "global_position", Vector2(gPosition.x - (margin / 2), gPosition.y - (margin / 2)), 0.2).from_current()
		#print("always")
