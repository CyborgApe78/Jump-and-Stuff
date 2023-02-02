extends Interactable

@onready var Stats: Resource = preload("res://src/actors/player/resources/playerStats.tres")
@export var stat: PlayerStats.list
@export var amount: int = 1
var blockColor: Color #TODO: block color


func _ready() -> void:
	super._ready()
	body_entered.connect(_on_state_changer_entered)


func _on_state_changer_entered(body: Player) -> void:
	if stat == PlayerStats.list.HealthMax:
		Stats.healthMax += amount
	elif stat == PlayerStats.list.MoveSpeed:
		Stats.baseSpeed += amount
	elif stat == PlayerStats.list.JumpHeight:
		Stats.jumpHeight += amount
	elif stat == PlayerStats.list.EnergyMax:
		Stats.energyMax += amount
	else:
		EventBus.debug.emit("Stat Changer error for " + str(stat) +" at: "  + str(name) + " at " + str(global_position))
