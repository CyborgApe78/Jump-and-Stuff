extends BaseMenu
#TODO: set number of abilities
#FIXME: need to call update to ability tracker after exiting. not working with EventBus.emit_signal("playerStatsCheck")
@onready var buttonAbilityAll: Button = $%All
@onready var buttonJumpAir: Button = $%JumpAir
@onready var buttonDashAll: Button = $%DashAll
@onready var buttonDashSide: Button = $%DashSide
@onready var buttonDashUp: Button = $%DashUp
@onready var buttonDashDown: Button = $%DashDown
@onready var buttonGroundPound: Button = $%GroundPound
@onready var buttonGlide: Button = $%Glide
@onready var buttonDive: Button = $%Dive


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


func _on_all_toggled(button_pressed: bool) -> void:
	buttonJumpAir.button_pressed = button_pressed
	buttonDashAll.button_pressed = button_pressed
	buttonGroundPound.button_pressed = button_pressed
	buttonGlide.button_pressed = button_pressed
	buttonDive.button_pressed = button_pressed


func _on_jump_air_toggled(button_pressed: bool) -> void:
	abilities.unlock_ability(PlayerAbilities.list.JumpAir, button_pressed)


func _on_dash_all_toggled(button_pressed: bool) -> void:
	buttonDashSide.button_pressed = button_pressed
	buttonDashUp.button_pressed = button_pressed
	buttonDashDown.button_pressed = button_pressed


func _on_dash_side_toggled(button_pressed: bool) -> void:
	abilities.unlock_ability(PlayerAbilities.list.DashSide, button_pressed)


func _on_dash_up_toggled(button_pressed: bool) -> void:
	abilities.unlock_ability(PlayerAbilities.list.DashUp, button_pressed)


func _on_dash_down_toggled(button_pressed: bool) -> void:
	abilities.unlock_ability(PlayerAbilities.list.DashDown, button_pressed)


func _on_ground_pound_toggled(button_pressed: bool) -> void:
	abilities.unlock_ability(PlayerAbilities.list.GroundPound, button_pressed)


func _on_glide_toggled(button_pressed: bool) -> void:
	abilities.unlock_ability(PlayerAbilities.list.Glide, button_pressed)


func _on_dive_toggled(button_pressed: bool) -> void:
	abilities.unlock_ability(PlayerAbilities.list.Dive, button_pressed)
