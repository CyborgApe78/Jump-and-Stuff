extends MarginContainer


var SettingsFile: Resource = preload("res://src/resources/SettingsConfig.tres")
var stats: Resource = preload("res://src/resources/gameStats.tres")

@onready var labelTime: RichTextLabel = $MarginContainer/TimeLabel
#var timePlayed: float 
var strTimeElapsed: String


func _ready() -> void:
#	timePlayed = stats.timePlayed
	show_timer()
	EventBus.settingsUpdate.connect(show_timer)

func _process(delta) -> void:
	stats.timePlayed += delta
	var mils = fmod(stats.timePlayed,1)*1000
	var secs = fmod(stats.timePlayed,60)
	var mins = fmod(stats.timePlayed, 3600) / 60
	var hr = fmod(stats.timePlayed,3600 * 60) / 3600
	strTimeElapsed = "%02d : %02d : %02d . %03d" % [hr, mins, secs, mils]
	
	labelTime.text = strTimeElapsed

func show_timer() -> void:
	visible = SettingsFile.showTimer
