class_name PlayerIdle extends MachineState


@export_group("States")
@export var walk: PlayerWalk
@export var jump: PlayerJump


func ready() -> void:
	pass


func enter() -> void:
	print("Idle")
	player.facing_logic(inputs.lastMoveDirection.x)
	characterRig.speed_bend_reset(transformTime)


func exit(_next_state: MachineState) -> void:
	pass


func handle_input(_event: InputEvent):
	if Input.is_action_just_pressed("jump"):
		FSM.change_state_to(jump)


func physics_update(_delta: float):
	pass


func state_update(_delta: float):
	if inputs.moveDirection != Vector2.ZERO:
		FSM.change_state_to(walk)


func visual_update(_delta: float):
	pass


func sound_update(_delta: float):
	pass
