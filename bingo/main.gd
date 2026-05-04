extends Control

@export var NumberButton : Button
@export var BallCounter : Label
@export var NumbersLabel : Label

var NumberScene = preload("res://number.tscn")

var BallCount : int = 48
var DrawnNumber : Array[int] = []
var CheckedNumbers : Array[int] = []
var PossibleDraws : Array = range(1,76)
#These are the numbers in each letter
var BingoArray : Dictionary = {"B":[],"I":[],"N":[],"G":[],"O":[]} 

var MidCheck : bool = false

var DiagonalWin : bool = false
var CornerWin : bool = false
var MidWin : bool = false
var FullWin : bool = false
var JackpotWin : bool = false

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
		CheckedNumbers.append(inst.number)
		check_game_state()

func button_hoverd(inst):
	if inst.disabled == false:
		#$hover.play()
		pass

func check_game_state():
	var DrawnNumberCount : int = DrawnNumber.size()
	if check_board_space(["N2"]) and MidWin == false and MidCheck == true:
		MidWin = true
		print("mid win")
	if DrawnNumberCount <= 33:
		#Checks for a corner game
		if check_board_space(["B0","B4","O4","O0"]) == true and CornerWin == false:
			CornerWin = true
			print("corner win")
	if DrawnNumberCount <= 38:
		#Checks for a diagonal game
		if check_board_space(["B0","B4","I1","I3","N2","G1","G3","O0","O4"]) == true and DiagonalWin == false:
			DiagonalWin = true
			print("diagonal win")
	if DrawnNumberCount <= 48:
		#Checks for a full game
		if check_board_space([]) and FullWin == false:
			FullWin = true
			print("big win")

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

func check_board_space(Balls : Array[String]):
	#This function accepts the a string that is a bingo letter and the index of the letters array.
	#Returns true if a number is present in CheckedNumbers in the given position.
	if Balls.size() != 0:
		for Ball in Balls:
			var BallLetter : String = Ball[0]
			var BoardIndex : int = int(Ball[1])
			if BingoArray[BallLetter][BoardIndex] not in CheckedNumbers:
				return false
		return true
	else:
		#Can't be botherd to type in all of the board positions.
		#Empty array asumes to check every single position
		for key in BingoArray:
			for i in 5:
				if BingoArray[key][i] not in CheckedNumbers:
					return false
		return true

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

var FirstNNumber : bool = false

func _on_number_button_pressed() -> void:
	#gets called when a ball is drawn
	if BallCount >= 1:
		BallCount -= 1
		DrawnNumber.append(PossibleDraws[0])
		#Chekcs for mid win
		if PossibleDraws[0] >= 31 and PossibleDraws[0] <= 45 and MidCheck == false:
			MidCheck = true
		PossibleDraws.pop_front()
		Update_info_panel()
	else:
		$Split/InfoPanel/VBoxContainer/NumberButton.disabled = true
