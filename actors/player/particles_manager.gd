class_name ParticleManager extends Node2D


@export_group("Connections")
@export var player: Player
@export var stats: StatsManager


func landed(particles: GPUParticles2D, maxSpeed: int, baseDuration: float, maxDuration: float, baseAmount: int = 8, maxAmount: int = 16) -> void:
	particles.lifetime = remap(abs(player.velocity.y), 0, maxSpeed, baseDuration, maxDuration)
	particles.amount = remap(abs(player.velocity.y), 0, maxSpeed, baseAmount, maxAmount)
	particles.restart()
	
	## should there be seperate ones for landed vs other particles
