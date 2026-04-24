extends Panel

var number : int = 0


func _ready() -> void:
	$Label.text = str(number)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
