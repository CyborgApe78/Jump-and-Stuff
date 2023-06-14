extends MarginContainer


@export var healthEmpty: TextureRect
@export var healthFull: TextureRect

@export var textureSize: int ## Size of asset ##
var stats: Resource = preload("res://src/actors/player/resources/playerStats.tres")


func _ready() -> void:
	show()
	set_health_max()
	EventBus.playerHealthChanged.connect(set_health)
	EventBus.playerStatsCheck.connect(set_health_max)


func set_health(amount:int) -> void:
	if amount != null:
		healthFull.size.x = amount * textureSize


func set_health_max() -> void:
	var amount = stats.healthMax
	if amount != null:
		healthEmpty.size.x = amount * textureSize

