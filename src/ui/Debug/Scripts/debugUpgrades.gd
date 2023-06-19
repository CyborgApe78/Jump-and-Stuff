extends Control


@export var buttonUpgradeAll: Button
@export var buttonProtectionHeat: Button
@export var buttonProtectionCold: Button
@export var buttonProtectionWater: Button
@export var buttonProtectionAcid: Button
@export var buttonProtectionLava: Button
@export var buttonDashChain: Button
@export var buttonLight: Button
@export var dashChainAmount: OptionButton

var Upgrades: Resource = preload("res://src/actors/player/resources/playerUpgrades.tres")
var Abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")
var Stats: Resource = preload("res://src/actors/player/resources/playerStats.tres")


func _ready() -> void:
	EventBus.debugMenuOpened.connect(check)


func check(BOOL) -> void:
	buttonProtectionHeat.button_pressed = Upgrades.unlockedProtectionHeat
	buttonProtectionCold.button_pressed = Upgrades.unlockedProtectionCold
	buttonProtectionWater.button_pressed = Upgrades.unlockedProtectionWater
	buttonProtectionAcid.button_pressed = Upgrades.unlockedProtectionAcid
	buttonProtectionLava.button_pressed = Upgrades.unlockedProtectionLava
	buttonDashChain.button_pressed = Upgrades.unlockedDashChain
	buttonLight.button_pressed = Upgrades.unlockedLight
	
	dashChainAmount.selected = Abilities.maxDashChain -1


func _on_upgrades_all_toggled(button_pressed: bool) -> void:
	buttonProtectionHeat.button_pressed = button_pressed
	buttonProtectionCold.button_pressed = button_pressed
	buttonProtectionWater.button_pressed = button_pressed
	buttonProtectionAcid.button_pressed = button_pressed
	buttonProtectionLava.button_pressed = button_pressed
	buttonDashChain.button_pressed = button_pressed
	buttonLight.button_pressed = button_pressed


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


func _on_dash_chain_toggled(button_pressed: bool) -> void:
	Upgrades.unlock(PlayerUpgrades.list.dashChain, button_pressed)


func _on_dash_chain_amount_item_selected(index: int) -> void:
	Abilities.maxDashChain = index + 1


func _on_light_toggled(button_pressed: bool) -> void:
	Upgrades.unlock(PlayerUpgrades.list.light, button_pressed)
