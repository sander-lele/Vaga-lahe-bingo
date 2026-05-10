extends Panel

signal remove_self

var text : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/Label.text = "  "+text


func _on_button_pressed() -> void:
	emit_signal("remove_self",self)
