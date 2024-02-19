extends Camera2D

#TODO: add input strength and/or accel
#TODO: extend phantom cam to trans

@export var telescope: Polygon2D

@export var moveSpeed: int = 20
@export var accel: float = 1.2


func _process(delta: float) -> void:
	telescope.look_at(global_position)


func _unhandled_input(event: InputEvent) -> void:
	if enabled:
		position += Input.get_vector("move_left", "move_right", "move_up", "move_down") * moveSpeed
