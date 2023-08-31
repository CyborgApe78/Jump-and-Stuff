extends UnlockableBase

#LOOKAT: negative stat change

@onready var Stats: Resource = preload("res://src/actors/player/resources/playerStats.tres")
@export var stat: PlayerStats.list
@export var amount: int = 1
var blockColor: Color #TODO: block color


func _ready() -> void:
	super._ready()
	body_entered.connect(_on_state_changer_entered)


func _on_state_changer_entered(body: Player) -> void:
	if stat == PlayerStats.list.HealthMax:
		stat_change(PlayerStats.list.HealthMax)
	elif stat == PlayerStats.list.MoveSpeed:
		stat_change(PlayerStats.list.MoveSpeed)
	elif stat == PlayerStats.list.JumpHeight:
		stat_change(PlayerStats.list.JumpHeight)
	elif stat == PlayerStats.list.EnergyMax:
		stat_change(PlayerStats.list.EnergyMax)
	else:
		EventBus.error.emit("Stat Changer error for " + str(stat) +" at: " + str(name) + " at " + str(global_position))


func stat_change(pStat) -> void:
	Stats.change(pStat, amount)
	announce_stat_change(pStat, amount)
	EventBus.playerStatsCheck.emit() #LOOKAT: is this the best place to call this


func announce_stat_change(pStat: int, amount: int) -> void:
	if pStat == PlayerStats.list.MoveSpeed:
		if amount > 0:
			EventBus.announce.emit("Move speed inscreased")
		else:
			EventBus.announce.emit("Move speed decreased")
	elif pStat == PlayerStats.list.JumpHeight:
		if amount > 0:
			EventBus.announce.emit("Jump Height inscreased")
		else:
			EventBus.announce.emit("Jump Height decreased")
	elif pStat == PlayerStats.list.HealthMax:
		if amount > 0:
			EventBus.announce.emit("Health inscreased")
		else:
			EventBus.announce.emit("Health decreased")
	elif pStat == PlayerStats.list.EnergyMax:
		if amount > 0:
			EventBus.announce.emit("Energy inscreased")
		else:
			EventBus.announce.emit("Energy decreased")
	else:
		EventBus.emit_signal("error", str("stat change error: ", stat))
