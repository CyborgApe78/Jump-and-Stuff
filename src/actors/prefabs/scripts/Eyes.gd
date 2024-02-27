extends Marker2D

#TODO: move raycast to a component
#TODO: add looking at ledges, hazards, other enemies

@export_category("Connections")
@export var pupilLeft: Line2D
@export var pupilRight: Line2D
@export var animPlayer: AnimationPlayer
@export var timerBlink: RandomTimer
@export var detector: RayCast2D

@export_category("")
@export var ignoreWalls: bool = false

var player

func _ready() -> void:
	start_blink_timer()
	
	if ignoreWalls:
		detector.set_collision_mask_value(CollisionLayers.Ground, false)

func _process(delta: float) -> void:
	if player:
		detector.look_at(player.global_position + Vector2(0, -64))
		if detector.is_colliding() and detector.get_collider() is Player:
			pupilLeft.look_at(player.global_position + Vector2(0, -64))
			pupilRight.look_at(player.global_position + Vector2(0, -64))
		else:
			pupilLeft.rotation_degrees = 0
			pupilRight.rotation_degrees = 0 #TODO: will need to slow move back to facing, need to get facing from parent
		


func blink() -> void:
	animPlayer.play("Blink")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Blink":
		start_blink_timer()


func start_blink_timer() -> void:
	timerBlink.start()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null
		pupilLeft.rotation_degrees = 0
		pupilRight.rotation_degrees = 0
		#TODO: need to makes eyes move back to default and get facing direction
