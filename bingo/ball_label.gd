extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var stylebox = StyleBoxFlat.new()
	stylebox.set_border_width_all(3)
	stylebox.set_corner_radius_all(15)
	stylebox.border_color = Color.WHITE
	add_theme_stylebox_override("normal", stylebox)
	match(text[0]):
		"B":
			stylebox.bg_color = Color(0.965, 0.0, 0.145)
		"I":
			stylebox.bg_color = Color(0.961, 0.765, 0.0)
		"N":
			stylebox.bg_color = Color(0.0, 0.8, 0.298)
		"G":
			stylebox.bg_color = Color(0.0, 0.718, 0.996)
		"O":
			stylebox.bg_color = Color(0.574, 0.426, 1.0)
