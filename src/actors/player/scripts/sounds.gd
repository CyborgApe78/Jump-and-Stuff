extends Node
#TODO: audio manager with settings
#TODO: like particles, extend off states

@onready var walk: AudioStreamPlayer = $walk
@onready var land: AudioStreamPlayer = $land
@onready var jump: AudioStreamPlayer = $jump
@onready var skid: AudioStreamPlayer = $skid
@onready var bonk: AudioStreamPlayer = $bonk
@onready var splat: AudioStreamPlayer = $splat
@onready var bodySlide: AudioStreamPlayer = $bodySlide
