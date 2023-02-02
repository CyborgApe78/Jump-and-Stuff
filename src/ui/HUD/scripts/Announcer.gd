extends MarginContainer

#TODO: setting to disable hud

@onready var announceLabel: RichTextLabel = $MarginContainer/Label
@onready var announceTimer: Timer = $Timer
@export var annoucmentLength: float = 2.0

var queue: Array = []
signal announcementFinished

func _ready() -> void:
	announceTimer.wait_time = annoucmentLength
	hide()
	EventBus.playerStatChange.connect(announce_stat_change)
	EventBus.playerAbilityUnlocked.connect(announce_ability_unlocked)
	announceTimer.timeout.connect(announce_finished)
	announcementFinished.connect(check_announcement_que)

func announce(announcment: String) -> void:
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
		announce(str("Move speed inscreased by ", amount))
	elif stat == PlayerStats.list.JumpHeight:
		announce(str("Jump height inscreased by ", amount))
	elif stat == PlayerStats.list.HealthMax:
		announce(str("Max health inscreased by ", amount))
	else:
		EventBus.emit_signal("error", str("stat change error: ", stat))


func announce_ability_unlocked(ability: int) -> void:
	if ability == PlayerAbilities.list.All:
		announce(str("The whole enchilada unlocked"))
	elif ability == PlayerAbilities.list.JumpAir:
		announce(str("Double Jump Unlocked "))
	elif ability == PlayerAbilities.list.JumpConsec:
		announce(str("Consec Jump Unlocked "))
	elif ability == PlayerAbilities.list.JumpWall:
		announce(str("Wall Jump Unlocked "))
	elif ability == PlayerAbilities.list.DashSide:
		announce(str("Dash Unlocked"))
	elif ability == PlayerAbilities.list.DashUp:
		announce(str("Dash Up Unlocked "))
	elif ability == PlayerAbilities.list.DashDown:
		announce(str("Dash Down Unlocked "))
	elif ability == PlayerAbilities.list.Glide:
		announce(str("Dash Up Unlocked "))
	elif ability == PlayerAbilities.list.Dive:
		announce(str("Dash Up Unlocked "))
	elif ability == PlayerAbilities.list.GroundPound:
		announce(str("Dash Up Unlocked "))
		#TODO: ability unlocked. have max jump count announced (double,triple, etc)
	else:
		EventBus.emit_signal("debug", str("ability unlock error: ", ability)) #TODO: make debug log
