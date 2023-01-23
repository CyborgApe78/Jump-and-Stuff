extends BaseMenu
#TODO: set number of abilities
#FIXME: need to call update to ability tracker after exiting. not working with EventBus.emit_signal("playerStatsCheck")
@onready var buttonAbilityAll: Button = $%All
var abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")


func enter() -> void:
	set_paused(true)
	visible = true
	buttonAbilityAll.grab_focus()


func exit() -> void:
	set_paused(false)
	visible = false


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("ui_pause") or Input.is_action_just_pressed("ui_back") or Input.is_action_just_pressed("debug_menu"):
		return State.Unpaused
	
	return State.Null


func state_check() -> int:
	return State.Null


func _on_all_pressed() -> void:
	abilities.unlock_ability(abilities.list.All)


func _on_reset_pressed() -> void:
	#TODO: figure way to set them all to false
	EventBus.emit_signal("debug", "reset not programmed")


func _on_jump_air_pressed() -> void:
	abilities.unlock_ability(abilities.list.JumpAir)


func _on_dash_all_pressed() -> void:
	abilities.unlock_ability(abilities.list.DashAll)


func _on_dash_side_pressed() -> void:
	abilities.unlock_ability(abilities.list.DashSide)


func _on_dash_up_pressed() -> void:
	abilities.unlock_ability(abilities.list.DashUp)


func _on_dash_down_pressed() -> void:
	abilities.unlock_ability(abilities.list.DashDown)
