extends Resource
class_name PlayerUpgrades

#TODO: PSpeed/Speedboost, light, velocity redirect from wall grab

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


enum list {
	Null,
	All,
	protectionAll,
	protectionHeat,
	protectionCold,
	protectionWater,
	protectionAcid,
	protectionLava,
	}


func unlock(upgrade: int, BOOL:bool) -> void:
	if upgrade == list.All:
		unlockedProtectionHeat = BOOL
		unlockedProtectionCold = BOOL
		unlockedProtectionWater = BOOL
		unlockedProtectionAcid = BOOL
		unlockedProtectionLava = BOOL
	elif upgrade == list.protectionAll:
		unlockedProtectionHeat = BOOL
		unlockedProtectionCold = BOOL
		unlockedProtectionWater = BOOL
		unlockedProtectionAcid = BOOL
		unlockedProtectionLava = BOOL
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
	else:
		EventBus.error.emit("Null Upgrade Unlocked " + str(upgrade) + " " + str(BOOL))
