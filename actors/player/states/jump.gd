class_name PlayerJump extends MachineState

@export_group("States")
@export var idle: PlayerIdle
@export var walk: PlayerWalk


func ready() -> void:
	pass


func enter() -> void:
	print("Jump")


func exit(_next_state: MachineState) -> void:
	pass


func handle_input(_event: InputEvent):
	pass


func physics_update(_delta: float):
	pass


func state_update(_delta: float):
	FSM.change_state_to(idle) #FIXME: Remove this


func visual_update(_delta: float):
	player.facing_logic(inputs.moveDirection.x)


func sound_update(_delta: float):
	pass
