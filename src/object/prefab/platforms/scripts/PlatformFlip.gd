extends Marker2D

## Flips when the Player jumps
#TODO: figure out how to 

@export_category("Connections")
@export var collision: VisibleCollisionShape2D
@export var platform: AnimatableBody2D
@export var animPlayer: AnimationPlayer

@export_category("")
@export var startLeft: bool
@export var timeFlip: float = 3


func _ready() -> void:
	collision.color = GameColor.JUMP
	if startLeft:
		platform.rotation_degrees = 180
	animPlayer.speed_scale = timeFlip
	EventBus.playerJumped.connect(flip_platform)
	EventBus.timeFreeze.connect(freeze)


func flip_platform() -> void:
	if not animPlayer.is_playing():
		if platform.rotation_degrees == 0:
			animPlayer.play("Rotate")
		else:
			animPlayer.play_backwards("Rotate")

func freeze(v: bool) -> void:
	if v:
		animPlayer.speed_scale = 0
	else:
		animPlayer.speed_scale = timeFlip
