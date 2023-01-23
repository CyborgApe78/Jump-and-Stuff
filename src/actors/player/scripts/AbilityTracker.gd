extends Node2D

@onready var dashSideTracker: Line2D = $DashSide
@onready var dashUpTracker: Line2D = $DashUp
@onready var dashDownTracker: Line2D = $DashDown

var abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")


func _ready() -> void:
	if !abilities.unlockedDashSide:
		dashSideTracker.visible = false
	if !abilities.unlockedDashUp:
		dashUpTracker.visible = false
	if !abilities.unlockedDashDown:
		dashDownTracker.visible = false
		
	EventBus.playerAbilitiesCheck.connect(self.tracker_visible)
	EventBus.playerAbilityTrackerCheck.connect(self.tracker_update) #TODO: replace other signals with this


func tracker_visible(ability) -> void:
	if abilities.unlockedDashSide:
		dashSideTracker.visible = true
	if abilities.unlockedDashUp:
		dashUpTracker.visible = true
	if abilities.unlockedDashDown:
		dashDownTracker.visible = true


func tracker_update() -> void:
		color_dash_side()
		color_dash_up()
		color_dash_down()


func color_dash_side() -> void:
	if abilities.remainingDashSide > 0:
		dashSideTracker.default_color = AbilityColor.dashSideColor
	else:
		dashSideTracker.default_color = AbilityColor.abilityUsedColor


func color_dash_up() -> void:
	if abilities.remainingDashUp > 0:
		dashUpTracker.default_color = AbilityColor.dashUpColor
	else:
		dashUpTracker.default_color = AbilityColor.abilityUsedColor


func color_dash_down() -> void:
	if abilities.remainingDashDown > 0:
		dashDownTracker.default_color = AbilityColor.dashDownColor
	else:
		dashDownTracker.default_color = AbilityColor.abilityUsedColor
