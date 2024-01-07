extends Area2D
class_name BounceBox


@onready var bounceStrength: int = _strength * Util.tileSize
@onready var bounceVelocity: Vector2 = Vector2(0,-bounceStrength).rotated(rotation) #TODO: proobably needs to be parent rotation

@export_range(1, 1000, 1) var _strength: int = 2:
	set(v):
		bounceStrength = v * Util.tileSize
		bounceVelocity = Vector2(0,-bounceStrength).rotated(rotation)
		_strength = v


func _ready() -> void:
	pass


func _on_body_entered(body: Actor) -> void:
	if body is Player:
		if body.global_position.y > global_position.y:
			body.sm.change_state(PlayerState.State.Jump)
		#body.velocity = bounceVelocity
	#TODO: find way to detect player is above.
	#TODO: needs to send to bounce state, and send an attack.eww() like resourse
