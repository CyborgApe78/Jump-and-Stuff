@tool
extends Polygon2D

## Area becomes visible when player enters

@export_group("Connections")
@export var collision: CollisionPolygon2D

@export_group("")
@export var transTime: float = 1.0
@export var stayVisible: bool = false


func _ready() -> void:
	if Engine.is_editor_hint():
		color = Color(0,0,0, .5)
	else:
		color = GameColor.ground
	
	if polygon.size() > 1:
		collision.polygon = polygon
	else:
		EventBus.error.emit(str("Hidden Area null: " + str(name) + " at " + str(global_position)))


func _on_body_entered(body: Node2D) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", Color(0,0,0, 0), transTime).from_current()


func _on_body_exited(body: Node2D) -> void:
	if not stayVisible:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "modulate", Color(0,0,0, 1), transTime).from_current()
