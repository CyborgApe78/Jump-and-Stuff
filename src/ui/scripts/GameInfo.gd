extends BaseMenu


@export var menuStats: Control
@export var menuWaypoints: Control
@export var menuSkills: Control
@export var menuCharms: Control
@export var infoContainter: Control
@export var labelCurrent: Label


enum tab {
	FastTravel,
	Skills,
	Charms,
	Stats,
}


func enter() -> void:
	set_paused(true)
	visible = true
	menuStats.stat_update()
	show_waypoints()
#	menuWaypoints.update_waypoints()


func exit() -> void:
	visible = false


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("ui_pause") or Input.is_action_just_pressed("ui_back") or Input.is_action_just_pressed("ui_info"):
		return State.Unpaused
	
	return State.Null


func state_check() -> int:
	return State.Null


func menu_hid() -> void:
	for child in infoContainter.get_children():
		child.visible = false 


func show_game_stats() -> void:
	menu_hid()
	labelCurrent.text = "Game Stats"
	menuStats.visible = true


func show_waypoints() -> void:
	menu_hid()
	labelCurrent.text = "Waypoints"
	menuWaypoints.visible = true


func show_skills() -> void:
	menu_hid()
	labelCurrent.text = "Skills"
	menuSkills.visible = true


func show_charms() -> void:
	menu_hid()
	labelCurrent.text = "Charms"
	menuCharms.visible = true
