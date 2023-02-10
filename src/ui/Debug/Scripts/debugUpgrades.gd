extends Control


@export var buttonUpgradeAll: Button
@export var buttonProtectionAll: Button
@export var buttonProtectionHeat: Button
@export var buttonProtectionCold: Button
@export var buttonProtectionWater: Button
@export var buttonProtectionAcid: Button
@export var buttonProtectionLava: Button

var Upgrades: Resource = preload("res://src/actors/player/resources/playerUpgrades.tres")


func _ready() -> void:
	EventBus.debugMenuOpened.connect(check)


func check(BOOL) -> void:
	buttonProtectionHeat.button_pressed = Upgrades.unlockedProtectionHeat
	buttonProtectionCold.button_pressed = Upgrades.unlockedProtectionCold
	buttonProtectionWater.button_pressed = Upgrades.unlockedProtectionWater
	buttonProtectionAcid.button_pressed = Upgrades.unlockedProtectionAcid
	buttonProtectionLava.button_pressed = Upgrades.unlockedProtectionLava


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
