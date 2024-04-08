extends PlayerInfo

#TODO: PoP changes direction when at top
#TODO: turn off aim indicator arrow
#FIXME: change position from feet to hands as anchor point
#TODO: rename to swing

## Jump Speed
@export var speed: int = 10

@export var swingPoint: Node2D


func enter() -> void:
	player.velocity = Vector2.ZERO
	abilities.reset(PlayerAbilities.listUse.All)
	player.animPlayer.play("Trapeze")
	#player.global_position = player.trapeze.global_position + Vector2(0, Util.tileSize * 2.5)


func exit() -> void:
	player.trapeze.remote.remote_path = NodePath("")


func physics(delta) -> void:
	pass


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justPressedJump: #FIXME: need find a way to slow down speed like gravity is being added
		player.velocity = player.trapeze.aimDirection * stats.dashSpeed
		return State.Fall

	return State.Null


func state_check(delta: float) -> int:
	

	return State.Null
