extends Resource
class_name PlayerUpgrades


var unlockedProtectionHeat: bool = false:
	set(v):
		unlockedProtectionHeat = v
		if unlockedProtectionHeat:
			EventBus.playerUpgradeUnlock.emit(list.protectionHeat)

var unlockedProtectionCold: bool = false:
	set(v):
		unlockedProtectionCold = v
		if unlockedProtectionCold:
			EventBus.playerUpgradeUnlock.emit(list.protectionCold)

var unlockedProtectionWater: bool = false:
	set(v):
		unlockedProtectionWater = v
		if unlockedProtectionWater:
			EventBus.playerUpgradeUnlock.emit(list.protectionWater)

var unlockedProtectionAcid: bool = false:
	set(v):
		unlockedProtectionAcid = v
		if unlockedProtectionAcid:
			EventBus.playerUpgradeUnlock.emit(list.protectionAcid)

var unlockedProtectionLava: bool = false:
	set(v):
		unlockedProtectionLava = v
		if unlockedProtectionLava:
			EventBus.playerUpgradeUnlock.emit(list.protectionLava)

var unlockedDashChain: bool = false:
	set(v):
		unlockedDashChain = v
		if unlockedDashChain:
			EventBus.playerUpgradeUnlock.emit(list.dashChain)

var unlockedDashTeleport: bool = false:
	set(v):
		unlockedDashTeleport = v
		if unlockedDashTeleport:
			EventBus.playerUpgradeUnlock.emit(list.dashTeleport)

var unlockedLight: bool = false:
	set(v):
		unlockedLight = v
		if unlockedLight:
			EventBus.playerUpgradeUnlock.emit(list.light)

var unlockedUnlimitedDash: bool = false:
	set(v):
		unlockedUnlimitedDash = v
		if unlockedUnlimitedDash:
			EventBus.playerUpgradeUnlock.emit(list.unlimitedDash)

enum list {
	Null,
	All,
	protectionHeat,
	protectionCold,
	protectionWater,
	protectionAcid,
	protectionLava,
	dashChain, 
	dashTeleport,
	light,
	unlimitedDash,
	}


func unlock(upgrade: int, BOOL:bool) -> void:
	if upgrade == list.All:
		unlockedProtectionHeat = BOOL
		unlockedProtectionCold = BOOL
		unlockedProtectionWater = BOOL
		unlockedProtectionAcid = BOOL
		unlockedProtectionLava = BOOL
		unlockedUnlimitedDash = BOOL
	elif upgrade == list.protectionHeat:
		unlockedProtectionHeat = BOOL
	elif upgrade == list.protectionCold:
		unlockedProtectionCold = BOOL
	elif upgrade == list.protectionWater:
		unlockedProtectionWater = BOOL
	elif upgrade == list.protectionAcid:
		unlockedProtectionAcid = BOOL
	elif upgrade == list.protectionLava:
		unlockedProtectionLava = BOOL
	elif upgrade == list.dashChain:
		unlockedDashChain = BOOL
	elif upgrade == list.light:
		unlockedLight = BOOL
	elif upgrade == list.unlimitedDash:
		unlockedUnlimitedDash = BOOL
	else:
		EventBus.error.emit("Null Upgrade Unlocked " + str(upgrade) + " " + str(BOOL))
