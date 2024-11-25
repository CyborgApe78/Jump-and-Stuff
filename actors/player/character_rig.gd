class_name CharacterRig extends Node2D


@export var player: Player
@export var stats: StatsManager
@export var squashAndStretch: Node2D


func speed_bend(forwardLean: bool = true, speed = stats.moveSpeed, leanAmount: float = 0.2) -> void:
	if forwardLean:
		skew = remap(player.facing * player.velocity.x, 0, speed, 0.0, player.facing * leanAmount)
	if !forwardLean:
		skew = remap(player.velocity.x, 0, speed, 0.0, -player.facing * leanAmount)

func speed_bend_reset(transformTime: float = 0.2)-> void:
	if skew != 0:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "skew", 0, transformTime).from_current()
