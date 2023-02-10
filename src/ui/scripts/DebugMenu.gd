extends BaseMenu
#TODO: check what is unlocked when opening
#FIXME: need to call update to ability tracker after exiting. not working with EventBus.emit_signal("playerStatsCheck")
@export var buttonAbilityAll: Button
@export var buttonJumpAll: Button
@export var buttonJumpAir: Button
@export var buttonJumpConsec: Button
@export var buttonDashAll: Button
@export var buttonDashSide: Button
@export var buttonDashUp: Button
@export var buttonDashDown: Button
@export var buttonGroundPound: Button
@export var buttonGlide: Button
@export var buttonDive: Button
@export var buttonUpgradeAll: Button
@export var buttonProtectionAll: Button
@export var buttonProtectionHeat: Button
@export var buttonProtectionCold: Button
@export var buttonProtectionWater: Button
@export var buttonProtectionAcid: Button
@export var buttonProtectionLava: Button


var Abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")
var Upgrades: Resource = preload("res://src/actors/player/resources/playerUpgrades.tres")


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
	buttonJumpAll.button_pressed = button_pressed
	buttonDashAll.button_pressed = button_pressed
	buttonGroundPound.button_pressed = button_pressed
	buttonGlide.button_pressed = button_pressed
	buttonDive.button_pressed = button_pressed


func _on_jump_air_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.JumpAir, button_pressed)


func _on_dash_all_toggled(button_pressed: bool) -> void:
	buttonDashSide.button_pressed = button_pressed
	buttonDashUp.button_pressed = button_pressed
	buttonDashDown.button_pressed = button_pressed


func _on_dash_side_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashSide, button_pressed)


func _on_dash_up_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashUp, button_pressed)


func _on_dash_down_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashDown, button_pressed)


func _on_ground_pound_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.GroundPound, button_pressed)


func _on_glide_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.Glide, button_pressed)


func _on_dive_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.Dive, button_pressed)


func _on_collision_toggled(button_pressed: bool) -> void:
	EventBus.debug.emit("Placeholder") #TODO


func _on_jump_number_item_selected(index: int) -> void:
	if index != -1:
		Abilities.maxJumpAir = index + 1


func _on_dash_number_item_selected(index: int) -> void:
	if index != -1:
		Abilities.maxDash = index + 1


func _on_jump_consec_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.JumpConsec, button_pressed)


func _on_jump_number_2_item_selected(index: int) -> void:
	if index != -1:
		Abilities.maxJumpConsec = index + 1


func _on_jump_all_toggled(button_pressed: bool) -> void:
	buttonJumpAir.button_pressed = button_pressed
	buttonJumpConsec.button_pressed = button_pressed


func _on_upgrades_all_toggled(button_pressed: bool) -> void:
	buttonProtectionAll.button_pressed = button_pressed


func _on_protection_all_toggled(button_pressed: bool) -> void:
	buttonProtectionHeat.button_pressed = button_pressed
	buttonProtectionCold.button_pressed = button_pressed
	buttonProtectionWater.button_pressed = button_pressed
	buttonProtectionAcid.button_pressed = button_pressed
	buttonProtectionLava.button_pressed = button_pressed


func _on_protection_heat_toggled(button_pressed: bool) -> void:
	Upgrades.unlock(PlayerUpgrades.list.protectionHeat, button_pressed)


func _on_protection_cold_toggled(button_pressed: bool) -> void:
	Upgrades.unlock(PlayerUpgrades.list.protectionCold, button_pressed)


func _on_protection_water_toggled(button_pressed: bool) -> void:
	Upgrades.unlock(PlayerUpgrades.list.protectionWater, button_pressed)


func _on_protection_acid_toggled(button_pressed: bool) -> void:
	Upgrades.unlock(PlayerUpgrades.list.protectionAcid, button_pressed)


func _on_protection_lava_toggled(button_pressed: bool) -> void:
	Upgrades.unlock(PlayerUpgrades.list.protectionLava, button_pressed)
