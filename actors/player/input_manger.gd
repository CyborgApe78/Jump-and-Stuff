class_name InputManager extends Node


var moveDirection: Vector2 = Vector2.ZERO
var lastMoveDirection: Vector2 = Vector2.RIGHT
var moveStrength: Vector2 = Vector2.ZERO


func _unhandled_input(_event: InputEvent) -> void:
	get_move_input()


func get_move_input() -> void:
	var deadzoneRadius: float = 0.2
	#TODO: make deadzone radius in settings
	var inputStrength: = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	
	moveStrength = inputStrength if inputStrength.length() > deadzoneRadius else Vector2.ZERO
	
	moveDirection = moveStrength.round()
	
	if moveDirection.x != 0:
		lastMoveDirection.x = moveDirection.x
	if moveDirection.y != 0:
		lastMoveDirection.y = moveDirection.y
