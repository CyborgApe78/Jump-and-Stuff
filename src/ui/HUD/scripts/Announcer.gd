extends MarginContainer

#TODO: setting to disable hud
#TODO: don't announce from debug

@onready var announceLabel: RichTextLabel = $MarginContainer/Label
@onready var announceTimer: Timer = $Timer
@export var annoucmentLength: float = 2.0

var inDebug: bool = false
var queue: Array = []
signal announcementFinished

func _ready() -> void:
	announceTimer.wait_time = annoucmentLength
	hide()
	EventBus.playerStatChange.connect(announce_stat_change)
	EventBus.playerAbilityUnlock.connect(announce_ability_unlock)
	EventBus.playerUpgradeUnlock.connect(announce_upgrade_unlock)
	EventBus.debugMenuOpened.connect(debug_check)
	announceTimer.timeout.connect(announce_finished)
	announcementFinished.connect(check_announcement_que)


func debug_check(BOOL) -> void:
	inDebug = BOOL


func announce(announcment: String) -> void:
	if !inDebug:
		if announceTimer.is_stopped():
			show()
			announceLabel.text = announcment
			announceTimer.start()
		else:
			store_announce(announcment)

func store_announce(announcment: String) -> void:
	queue.append(announcment)

func announce_finished() -> void:
	announceLabel.text = ""
	hide()
	announcementFinished.emit()

func check_announcement_que() -> void:
	pass
	if not queue.is_empty():
		var nextAnnouncement = queue.pop_front()
		announce(nextAnnouncement)

func announce_stat_change(stat: int, amount: int) -> void:
	if stat == PlayerStats.list.MoveSpeed:
		if amount > 0:
			announce("Move speed inscreased")
		else:
			announce("Move speed decreased")
	elif stat == PlayerStats.list.JumpHeight:
		if amount > 0:
			announce("Jump Height inscreased")
		else:
			announce("Jump Height decreased")
	elif stat == PlayerStats.list.HealthMax:
		if amount > 0:
			announce("Health inscreased")
		else:
			announce("Health decreased")
	elif stat == PlayerStats.list.EnergyMax:
		if amount > 0:
			announce("Energy inscreased")
		else:
			announce("Energy decreased")
	else:
		EventBus.emit_signal("error", str("stat change error: ", stat))


func announce_ability_unlock(ability: int) -> void:
	if ability == PlayerAbilities.list.All:
		announce(str("The whole enchilada unlocked"))
	elif ability == PlayerAbilities.list.JumpAir:
		announce(str("Air Jump Unlocked"))
	elif ability == PlayerAbilities.list.JumpConsec:
		announce(str("Consec Jump Unlocked"))
	elif ability == PlayerAbilities.list.JumpWall:
		announce(str("Wall Jump Unlocked"))
	elif ability == PlayerAbilities.list.DashSide:
		announce(str("Dash Unlocked"))
	elif ability == PlayerAbilities.list.DashUp:
		announce(str("Dash Up Unlocked"))
	elif ability == PlayerAbilities.list.DashDown:
		announce(str("Dash Down Unlocked"))
	elif ability == PlayerAbilities.list.Glide:
		announce(str("Glide Unlocked"))
	elif ability == PlayerAbilities.list.Dive:
		announce(str("Dive Unlocked"))
	elif ability == PlayerAbilities.list.GroundPound:
		announce(str("Ground Pound Unlocked"))
	else:
		EventBus.emit_signal("debug", str("ability unlock error: ", ability)) #TODO: make debug log


func announce_upgrade_unlock(upgrade: int) -> void:
	if upgrade == PlayerUpgrades.list.All:
		announce(str("The whole enchilada unlocked"))
	elif upgrade == PlayerUpgrades.list.protectionAll:
		announce(str("All Protections Unlocked"))
	elif upgrade == PlayerUpgrades.list.protectionHeat:
		announce(str("Heat Protection Unlocked"))
	elif upgrade == PlayerUpgrades.list.protectionCold:
		announce(str("Cold Protection Unlocked"))
	elif upgrade == PlayerUpgrades.list.protectionWater:
		announce(str("Water Protection Unlocked"))
	elif upgrade == PlayerUpgrades.list.protectionAcid:
		announce(str("Acid Protection Unlocked"))
	elif upgrade == PlayerUpgrades.list.protectionLava:
		announce(str("Lava Protection Unlocked"))
	else:
		EventBus.emit_signal("debug", str("ability unlock error: ", upgrade)) #TODO: make debug log
