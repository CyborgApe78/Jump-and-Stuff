extends Area2D
class_name EnviromentalEffects


enum directions {Null, UP, UPLEFT, UPRIGHT, LEFT, RIGHT, DOWN, DOWNLEFT, DOWNRIGHT}

const UP = Vector2.UP
const UPLEFT = Vector2(-1, -1)
const UPRIGHT = Vector2(1, -1)
const LEFT = Vector2.LEFT
const RIGHT = Vector2.RIGHT
const DOWN = Vector2.DOWN
const DOWNLEFT = Vector2(-1, 1)
const DOWNRIGHT = Vector2(1, 1)

@export var strength: int = 64
#@export var direction: directions #FIXME: currently only vertical wind


#TODD: water jets, water fountains
