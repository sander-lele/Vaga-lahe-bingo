extends Camera2D

@export var RandomStrength : float = 30.0
@export var ShakeFade : float = 5.0

var ShakeStrenght : float = 0.0

func apply_shake():
	ShakeStrenght = RandomStrength

func _process(delta: float) -> void:
	if ShakeStrenght > 0:
		ShakeStrenght = lerpf(ShakeStrenght,0,ShakeFade * delta)
	offset = random_offset()

func random_offset() -> Vector2:
	return Vector2(randf_range(-ShakeStrenght,ShakeStrenght),randf_range(-ShakeStrenght,ShakeStrenght))
