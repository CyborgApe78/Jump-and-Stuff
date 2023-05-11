@tool
extends Line2D


@onready var parent = get_parent()
@export var thickness: float = 1.2

func _ready():
	width_curve = parent.width_curve
	width = parent.width * thickness


func _process(delta): #TODO: find a way that this isn't running all the time
	if points != parent.points:
		points = parent.points
