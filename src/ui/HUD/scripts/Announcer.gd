extends MarginContainer


@onready var announceLabel: RichTextLabel = $MarginContainer/Label
@onready var announceTimer: Timer = $Timer
@export var annoucmentLength: float = 2.0

var inDebug: bool = false
var queue: Array = []
signal announcementFinished


func _ready() -> void:
	announceTimer.wait_time = annoucmentLength
	hide()
	EventBus.announce.connect(announce)
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
