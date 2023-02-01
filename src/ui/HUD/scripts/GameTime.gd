extends MarginContainer

#TODO: setting to disable
#TODO: dungeon time

@export var gameStats: Resource
@onready var labelTime: RichTextLabel = $MarginContainer/TimeLabel
var timePlayed: float
var strTimeElapsed: String


func _ready() -> void:
	timePlayed = gameStats.timePlayed
#	show_timer()
#	EventBus.connect("settingsUpdate", self, "show_timer")

func _process(delta) -> void:
	timePlayed += delta
	var mils = fmod(timePlayed,1)*1000
	var secs = fmod(timePlayed,60)
	var mins = fmod(timePlayed, 3600) / 60
	var hr = fmod(timePlayed,3600 * 60) / 3600
	strTimeElapsed = "%02d : %02d : %02d . %03d" % [hr, mins, secs, mils]
	
	labelTime.text = strTimeElapsed

#func show_timer() -> void:
#	visible = SettingsFile.showTimer
