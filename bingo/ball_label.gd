extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match(text[0]):
		"B":
			$ColorRect.color = Color(0.965, 0.0, 0.145)
		"I":
			$ColorRect.color = Color(0.961, 0.765, 0.0)
		"N":
			$ColorRect.color = Color(0.0, 0.8, 0.298)
		"G":
			$ColorRect.color = Color(0.0, 0.718, 0.996)
		"O":
			$ColorRect.color = Color(0.574, 0.426, 1.0)
