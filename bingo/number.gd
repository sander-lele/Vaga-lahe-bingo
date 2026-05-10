extends Button

@export var NumberLabel : Label
@export var Particle : CPUParticles2D

var Number : int = 0


func _ready() -> void:
	$Label.text = str(Number)
