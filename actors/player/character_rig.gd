class_name CharacterRig extends Node2D


@export var player: Player
@export var stats: StatsManager
@export var velocity: VelocityManager


func _process(delta: float) -> void:
	squash_and_stretch(delta)


func speed_bend(forwardLean: bool = true, speed = stats.moveSpeed, leanAmount: float = 0.2) -> void:
	if forwardLean:
		skew = remap(player.facing * player.velocity.x, 0, speed, 0.0, player.facing * leanAmount)
	if !forwardLean:
		skew = remap(player.velocity.x, 0, speed, 0.0, -player.facing * leanAmount)


func speed_bend_reset(transformTime: float = 0.2)-> void:
	if skew != 0:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "skew", 0, transformTime).from_current()


func squash_and_stretch(delta):
	var maxStretch: int
	
	if player.velocity.y < 0:
		maxStretch = max(player.velocity.y, stats.jumpVelocity)
	else:
		maxStretch = min(player.velocity.y, stats.jumpVelocity)
	
	if not player.is_on_floor():
		scale.y = remap(abs(maxStretch), 0, abs(stats.jumpVelocity), 0.75, 1.25)
		scale.x = remap(abs(maxStretch), 0, abs(stats.jumpVelocity), 1.25, 0.75)
	
	scale.x = lerp(scale.x, 1.0, 1.0 - pow(0.01, delta)) #FIXME: flips back to toght
	scale.y = lerp(scale.y, 1.0, 1.0 - pow(0.01, delta))
