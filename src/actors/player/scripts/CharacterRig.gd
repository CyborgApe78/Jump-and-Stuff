extends Node2D


var transformTime: float = 0.2


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




