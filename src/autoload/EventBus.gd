extends Node

signal playerHealthChanged
signal playerStatsCheck
signal playerAbilityUnlock(ability)
signal playerUpgradeUnlock(upgrade)
signal playerStatChange(stat, amount)
signal playerConsecutiveJump
signal playerStateChange(states)
signal playerActionAnnounce
signal teleportPlayer(location)

signal playerDashed
signal playerJumped
signal playerBashed
signal playerRolled
signal playerLanded
signal playerAirborne

signal playerDied

signal checkKeys
signal showKeys

signal announce(info)

signal timeFreeze(bool)

signal checkpointEntered

signal debugState(info)
signal debugVelocity(info)
signal debugMoveDirection(info)
signal debugIsGrounded(info)
signal debugGroundAngle(info)
signal debug(info)
signal debug2(info)
signal debug3(info)
signal debugMenuOpened(bool)
signal error(info)


signal helperUsed(info)

signal menuChanged
signal settingsUpdate
signal showDebug(bool)
signal cursorPosition(gPosition: Vector2, lPositon: Vector2, size: Vector2)

signal rumble(min: float, max: float, duration: float)
