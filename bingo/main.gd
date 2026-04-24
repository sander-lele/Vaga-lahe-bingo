extends Control

var NumberScene = preload("res://number.tscn")

var BArray : Array = []
var IArray : Array = []
var NArray : Array = []
var GArray : Array = []
var OArray : Array = []

var BArrayRange : Array = range(1,16)
var IArrayRange : Array = range(16,31)
var NArrayRange : Array = range(31,46)
var GArrayRange : Array = range(46,61)
var OArrayRange : Array = range(61,76)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_board()
	draw_board()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		get_tree().reload_current_scene()

func create_board():
	BArrayRange.shuffle()
	IArrayRange.shuffle()
	NArrayRange.shuffle()
	GArrayRange.shuffle()
	OArrayRange.shuffle()
	for i in range(5):
		BArray.append(BArrayRange[0])
		BArrayRange.pop_front()
		IArray.append(IArrayRange[0])
		IArrayRange.pop_front()
		NArray.append(NArrayRange[0])
		NArrayRange.pop_front()
		GArray.append(GArrayRange[0])
		GArrayRange.pop_front()
		OArray.append(OArrayRange[0])
		OArrayRange.pop_front()

func draw_board():
	for i in BArray:
		var NumberInstance = NumberScene.instantiate()
		NumberInstance.number = i
		$Board/B/VBoxContainer/NumberHolder.add_child(NumberInstance)
	for i in IArray:
		var NumberInstance = NumberScene.instantiate()
		NumberInstance.number = i
		$Board/I/VBoxContainer/NumberHolder.add_child(NumberInstance)
	for i in NArray:
		var NumberInstance = NumberScene.instantiate()
		NumberInstance.number = i
		$Board/N/VBoxContainer/NumberHolder.add_child(NumberInstance)
	for i in GArray:
		var NumberInstance = NumberScene.instantiate()
		NumberInstance.number = i
		$Board/G/VBoxContainer/NumberHolder.add_child(NumberInstance)
	for i in OArray:
		var NumberInstance = NumberScene.instantiate()
		NumberInstance.number = i
		$Board/O/VBoxContainer/NumberHolder.add_child(NumberInstance)
	
