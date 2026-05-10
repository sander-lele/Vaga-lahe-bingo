extends Button

@export var NumberLabel : Label

var Number : int = 0


func _ready() -> void:
	$Label.text = str(Number)
