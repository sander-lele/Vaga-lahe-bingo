extends Button

var Number : int = 0
var NumberMin : int = 0
var NumberMax : int = 0

func _ready() -> void:
	pass

func _show_number() -> void:
	$Self.visible = false
	$Label.text = str(Number)
