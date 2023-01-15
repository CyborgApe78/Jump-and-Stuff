extends Node
#TODO: audio manager with settings
#TODO: make resources that send to audiplayer

@onready var walk: AudioStreamPlayer = $walk
@onready var land: AudioStreamPlayer = $land
@onready var jump: AudioStreamPlayer = $jump
@onready var skid: AudioStreamPlayer = $skid
@onready var bonk: AudioStreamPlayer = $bonk
@onready var splat: AudioStreamPlayer = $splat
@onready var bodySlide: AudioStreamPlayer = $bodySlide
