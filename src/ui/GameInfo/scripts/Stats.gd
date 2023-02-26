extends GridContainer


@export var labelPlayTime: Label
@export var labelDeath: Label
@export var labelJump: Label
@export var labelDashSide: Label
@export var labelDashUp: Label
@export var labelDashDown: Label

var Stats: Resource = preload("res://src/resources/gameStats.tres")

#TODO: change label of dash side from dash 
func stat_update() -> void:
	labelPlayTime.text = convert_time(Stats.timePlayed)
	labelDeath.text = str(Stats.deaths)
	labelJump.text = str(Stats.jumps)
	labelDashSide.text = str(Stats.dashSide)
	labelDashUp.text = str(Stats.dashUp)
	labelDashDown.text = str(Stats.dashDown)

func convert_time(time) -> String:
	var mils = fmod(Stats.timePlayed,1)*1000
	var secs = fmod(Stats.timePlayed,60)
	var mins = fmod(Stats.timePlayed, 3600) / 60
	var hr = fmod(Stats.timePlayed,3600 * 60) / 3600
	var strTimeElapsed = "%02d : %02d : %02d . %03d" % [hr, mins, secs, mils]
	
	return strTimeElapsed
