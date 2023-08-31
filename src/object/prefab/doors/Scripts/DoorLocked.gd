extends StaticBody2D


@export var labelAmount: Label
@export var amount: int = 1

var inventory: Resource = preload("res://src/actors/player/resources/Inventory.tres")


func _ready() -> void:
	labelAmount.text = str(amount)


func _on_body_entered(body: Player) -> void:
	if inventory.can_use_keys(amount):
		queue_free() #TODO: make interactable and save that the door has been opened
