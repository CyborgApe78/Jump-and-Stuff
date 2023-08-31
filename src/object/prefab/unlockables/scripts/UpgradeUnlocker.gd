extends UnlockableBase

#TODO: make one for each. stop exporting

@onready var Upgrades: Resource = preload("res://src/actors/player/resources/playerUpgrades.tres")
@export var upgrade: PlayerUpgrades.list
@export var unlock: bool = true
var blockColor: Color #TODO: block color


func _ready() -> void:
	super._ready()
	body_entered.connect(_on_upgrade_unlocker_entered)


func _on_upgrade_unlocker_entered(body: Player) -> void:
	if upgrade == PlayerUpgrades.list.protectionHeat:
		upgrade_unlock(PlayerUpgrades.list.protectionHeat)
	elif upgrade == PlayerUpgrades.list.protectionCold:
		upgrade_unlock(PlayerUpgrades.list.protectionCold)
	elif upgrade == PlayerUpgrades.list.protectionWater:
		upgrade_unlock(PlayerUpgrades.list.protectionWater)
	elif upgrade == PlayerUpgrades.list.protectionAcid:
		upgrade_unlock(PlayerUpgrades.list.protectionAcid)
	elif upgrade == PlayerUpgrades.list.protectionLava:
		upgrade_unlock(PlayerUpgrades.list.protectionLava)
	else:
		EventBus.error.emit("Upgrade Unlocker error for " + str(upgrade) +" at: " + str(name) + " at " + str(global_position))


func upgrade_unlock(pUpgrade) -> void:
	Upgrades.unlock(pUpgrade, unlock)
	if unlock:
		announce_upgrade_unlock(pUpgrade)


func announce_upgrade_unlock(pUpgrade: int) -> void:
	if pUpgrade == PlayerUpgrades.list.All:
		EventBus.announce.emit(str("The whole enchilada unlocked"))
	elif pUpgrade == PlayerUpgrades.list.protectionHeat:
		EventBus.announce.emit(str("Heat Protection Unlocked"))
	elif pUpgrade == PlayerUpgrades.list.protectionCold:
		EventBus.announce.emit(str("Cold Protection Unlocked"))
	elif pUpgrade == PlayerUpgrades.list.protectionWater:
		EventBus.announce.emit(str("Water Protection Unlocked"))
	elif pUpgrade == PlayerUpgrades.list.protectionAcid:
		EventBus.announce.emit(str("Acid Protection Unlocked"))
	elif pUpgrade == PlayerUpgrades.list.protectionLava:
		EventBus.announce.emit(str("Lava Protection Unlocked"))
	else:
		EventBus.debug.emit(str("ability unlock error: ", upgrade))
