extends Panel

#FIXME: position not right when opened
#TODO: adjust z layer so it is ahead of panesl, below buttons


@export var defaultButton: Button
@export var margin: int = 20


func _ready() -> void:
	size = Vector2(defaultButton.size.x + margin, defaultButton.size.y + margin)
	global_position = Vector2(defaultButton.global_position.x - (margin / 2), defaultButton.global_position.y - (margin / 2))
	EventBus.cursorPosition.connect(_on_focused)

func _on_focused(gPosition: Vector2, lPosition: Vector2, size: Vector2) -> void:
	if visible != true:
		visible = true
	
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(self, "size", Vector2(size.x + margin, size.y + margin), 0.2).from_current()
	tween.tween_property(self, "global_position", Vector2(gPosition.x - (margin / 2), gPosition.y - (margin / 2)), 0.2).from_current()
