extends Area2D
class_name UnlockableBase


func _ready() -> void:
	body_entered.connect(_on_unlockable_entered)


func _on_unlockable_entered(body: Player) -> void:
	queue_free()
