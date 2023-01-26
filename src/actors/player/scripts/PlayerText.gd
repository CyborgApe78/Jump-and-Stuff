extends RichTextLabel


@onready var announcementClearTimer: Timer = $AnnounceClear

@export var announcementDuration: float = 0.7

var queue: Array = []
signal announcementFinished


func _ready() -> void:
	announcementClearTimer.wait_time = announcementDuration 
	hide()
	announcementFinished.connect(check_announcement_que)
	EventBus.playerInfo.connect(announce_action)
	announcementClearTimer.timeout.connect(announce_finished)


func announce_finished() -> void:
	text = ""
	hide()
	emit_signal("announcementFinished")


func announce(announcment: String) -> void:
	if announcementClearTimer.is_stopped():
		show()
		text = announcment
		announcementClearTimer.start()
	else:
		store_announce(announcment)


func store_announce(announcment: String) -> void:
	queue.append(announcment)


func check_announcement_que() -> void:
	if not queue.is_empty():
		var nextAnnouncement = queue.pop_front()
		announce(nextAnnouncement)


func announce_action(action: String) -> void:
	announce("[center][rainbow][wave]" + action)
