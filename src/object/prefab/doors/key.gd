extends Area2D
#TODO: use pickup containter instead of placing it in world

var inventory: Resource = preload("res://src/actors/player/resources/Inventory.tres")


func _on_body_entered(body: Player):
	inventory.keys += 1
	EventBus.announce.emit("Key")
	EventBus.showKeys.emit()
	queue_free()
