extends MarginContainer


@export var labelCurrent: Label
@export var labelMax: Label

var stats: Resource = preload("res://src/actors/player/resources/playerStats.tres")


func _ready() -> void:
	show()
	set_health_max()
	EventBus.playerHealthChanged.connect(set_health)
	EventBus.playerStatsCheck.connect(set_health_max)


func set_health(amount:int) -> void:
	if amount != null:
		labelCurrent.text = str(amount)


func set_health_max() -> void:
	labelMax.text = "/ " + str(stats.healthMax)

