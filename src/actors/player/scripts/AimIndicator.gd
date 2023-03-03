extends Marker2D


@export var color: Color = Color.FOREST_GREEN
@export var raycast: RayCast2D

@onready var player: CharacterBody2D = owner

var SettingsConfig: Resource = preload("res://src/resources/SettingsConfig.tres")


func _physics_process(delta: float) -> void:
	if SettingsConfig.showAimIndicator: #TODO: set own var, not check resource all the time
		if player.aimDirection != Vector2.ZERO:
			visible = true
			var cast: Vector2 = player.aimDirection * raycast.target_position.length()
			var angle: = cast.angle()
			rotation = angle
			raycast.force_raycast_update()
		elif player.aimDirection == Vector2.ZERO and visible:
				visible = false
