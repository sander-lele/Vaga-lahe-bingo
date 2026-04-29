extends Control

@export var NumberButton : Button
@export var BallCounter : Label
@export var NumbersLabel : Label

var NumberScene = preload("res://number.tscn")

var BallCount : int = 48
var DrawnNumber : Array = []
var PossibleDraws : Array = range(1,76)
#These are the numbers in each letter
var BingoArray : Dictionary = {"B":[],"I":[],"N":[],"G":[],"O":[]} 

#These show the possible number range for each letter
var BingoArrayRange : Dictionary = {"B":range(1,16),"I":range(16,31),"N":range(31,46),"G":range(46,61),"O":range(61,76)}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_board()
	draw_board()
	PossibleDraws.shuffle()
	#connects the main script with all the board buttons.
	var buttons = get_tree().get_nodes_in_group("button")
	for i in buttons.size():
		if buttons[i].is_connected("pressed", Callable(self,"button_pressed")) == false or buttons[i].is_connected("mouse_entered", Callable(self,"button_hoverd")) == false:
			buttons[i].pressed.connect(button_pressed.bind(buttons[i]))
			buttons[i].mouse_entered.connect(button_hoverd.bind(buttons[i]))

func button_pressed(inst : Button):
	#$pressed.play()
	if DrawnNumber.has(inst.number):
		inst.disabled = true
		check_game_state()

func button_hoverd(inst):
	if inst.disabled == false:
		#$hover.play()
		pass

func check_game_state():
	if DrawnNumber.count() <= 33:
		#Checks for a corner game
		check_board_space("B",0)

func _physics_process(_delta: float) -> void:
	#Please please please remove later
	if Input.is_action_just_pressed("debug"):
		get_tree().reload_current_scene()

func create_board():
	#Shuffels the range array
	for key in BingoArrayRange:
		for i in 5:
			BingoArrayRange[key].shuffle()
			BingoArray[key].append(BingoArrayRange[key][0])
			BingoArrayRange[key].pop_front()

func reset_range_array():
	BingoArrayRange = {"B":range(1,16),"I":range(16,31),"N":range(31,46),"G":range(46,61),"O":range(61,76)}

func draw_board():
	#Adds the number visuals
	for key in BingoArray:
		for i in 5:
			var NumberInstance = NumberScene.instantiate()
			NumberInstance.number = BingoArray[key][i]
			get_node("Split/Board/"+str(key)+"/VBoxContainer/NumberHolder").add_child(NumberInstance)

func Update_info_panel():
	$Split/InfoPanel/VBoxContainer/NumbersPanel.text = str(DrawnNumber)

func check_board_space(Letter : string, Index : int):
	if BingoArray[Letter][Index] ==:
		return true
	else:
		return false

func convert_number_to_bingo_ball(Num : int):
	var Result : String = "" 
	if Num <= 15:
		Result = "B"+str(Num)
	elif Num <= 30:
		Result = "I"+str(Num)
	elif Num <= 45:
		Result = "N"+str(Num)
	elif Num <= 60:
		Result = "G"+str(Num)
	elif Num <= 75:
		Result = "O"+str(Num)
	return Result

func _on_number_button_pressed() -> void:
	#gets called when a ball is drawn
	if BallCount >= 1:
		BallCount -= 1
		DrawnNumber.append(PossibleDraws[0])
		PossibleDraws.pop_front()
		Update_info_panel()
	else:
		$Split/InfoPanel/VBoxContainer/NumberButton.disabled = true
