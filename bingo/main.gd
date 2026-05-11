extends Control

@export var NumberButton : Button
@export var BallCounter : Label
@export var NumbersLabel : Label

var NumberScene = preload("res://number.tscn")
var BallLabelScene = preload("res://BallLabel.tscn")

var BallCount : int = 48
var DrawnNumber : Array[int] = []
var CheckedNumbers : Array[int] = []
var PossibleDraws : Array = range(1,76)
#These are the numbers in each letter
var BingoArray : Dictionary = {"B":[0,0,0,0,0],"I":[0,0,0,0,0],"N":[0,0,0,0,0],"G":[0,0,0,0,0],"O":[0,0,0,0,0]} 

var AutoSelect : bool = false
var SelfInputedNumbers : Dictionary[int, Button] = {}

var MidCheck : bool = false
var DiagonalWin : bool = false
var CornerWin : bool = false
var MidWin : bool = false
var FullWin : bool = false

#These show the possible number range for each letter
var BingoArrayRange : Dictionary = {"B":range(1,16),"I":range(16,31),"N":range(31,46),"G":range(46,61),"O":range(61,76)}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for GamePanels : Panel in $Split/InfoPanel/VBoxContainer/HBoxContainer.get_children():
		GamePanels.get_theme_stylebox("panel").bg_color = Color(0.733, 0.369, 0.145)
	if Global.SelfGen == true:
		for SelfNum : int in Global.SelectedValues:
			var SelfBall = convert_number_to_bingo_ball(SelfNum)
			var SelfLetter = SelfBall[0]
			BingoArray[SelfLetter][randi_range(0,4)] = SelfNum
	create_board()
	draw_board()
	PossibleDraws.shuffle()
	#connects the main script with all the board buttons.
	var buttons = get_tree().get_nodes_in_group("button")
	var BingoButtons = get_tree().get_nodes_in_group("bingobutton")
	for i in buttons.size():
		if buttons[i].is_connected("pressed", Callable(self,"button_pressed")) == false or buttons[i].is_connected("mouse_entered", Callable(self,"button_hoverd")) == false:
			buttons[i].pressed.connect(button_pressed)
			buttons[i].mouse_entered.connect(button_hoverd.bind(buttons[i]))
	for BingoButton : Button in BingoButtons:
		if BingoButton.is_connected("pressed", Callable(self,"bingo_button_pressed")) == false or BingoButton.is_connected("mouse_entered", Callable(self,"button_hoverd")) == false:
			BingoButton.pressed.connect(bingo_button_pressed.bind(BingoButton))
			BingoButton.mouse_entered.connect(button_hoverd.bind(BingoButton))

func bingo_button_pressed(inst : Button):
	#$pressed.play()
	if DrawnNumber.has(inst.Number) and inst.disabled == false:
		inst.disabled = true
		inst.Particle.emitting = true
		CheckedNumbers.append(inst.Number)
		check_game_state()
		$Sounds/BingoSelect.play()
		$Camera2D.apply_shake()

func button_pressed():
	$Sounds/Select.play()

func button_hoverd(inst):
	if inst.disabled == false:
		$Sounds/Hover.play()
		pass

func check_game_state():
	var DrawnNumberCount : int = DrawnNumber.size()
	if check_board_space(["N2"]) and MidWin == true:
		$Split/InfoPanel/VBoxContainer/HBoxContainer/Middle.get_theme_stylebox("panel").bg_color = Color(0.059, 0.859, 0.016)
		$Sounds/Correct.play()
	if DrawnNumberCount <= 33:
		#Checks for a corner game
		if check_board_space(["B0","B4","O4","O0"]) == true and CornerWin == false:
			CornerWin = true
			print("win")
			$Split/InfoPanel/VBoxContainer/HBoxContainer/Corner.get_theme_stylebox("panel").bg_color = Color(0.059, 0.859, 0.016)
			$Sounds/Correct.play()
	elif CornerWin == false:
		$Split/InfoPanel/VBoxContainer/HBoxContainer/Corner.get_theme_stylebox("panel").bg_color = Color.GRAY
	if DrawnNumberCount <= 33 and MidWin == false:
		$Split/InfoPanel/VBoxContainer/HBoxContainer/Middle.get_theme_stylebox("panel").bg_color = Color.GRAY
	if DrawnNumberCount <= 38:
		#Checks for a diagonal game
		if check_board_space(["B0","B4","I1","I3","N2","G1","G3","O0","O4"]) == true and DiagonalWin == false:
			DiagonalWin = true
			$Split/InfoPanel/VBoxContainer/HBoxContainer/Diagonal.get_theme_stylebox("panel").bg_color = Color(0.059, 0.859, 0.016)
			$Sounds/Correct.play()
	elif DiagonalWin == false:
		$Split/InfoPanel/VBoxContainer/HBoxContainer/Diagonal.get_theme_stylebox("panel").bg_color = Color.GRAY
	if DrawnNumberCount <= 48:
		#Checks for a full game
		if check_board_space([]) and FullWin == false:
			FullWin = true
			$Split/InfoPanel/VBoxContainer/HBoxContainer/Full.get_theme_stylebox("panel").bg_color = Color(0.059, 0.859, 0.016)
			$Sounds/Correct.play()


func create_board():
	#Shuffels the range array
	for key in BingoArrayRange:
		for i in 5:
			if BingoArray[key][i] == 0:
				BingoArrayRange[key].shuffle()
				BingoArray[key][i] = BingoArrayRange[key][0]
				BingoArrayRange[key].pop_front()
	#resets the range array for further use
	BingoArrayRange = {"B":range(1,16),"I":range(16,31),"N":range(31,46),"G":range(46,61),"O":range(61,76)}

func reset_range_array():
	BingoArrayRange = {"B":range(1,16),"I":range(16,31),"N":range(31,46),"G":range(46,61),"O":range(61,76)}

func draw_board():
	#Adds the number visuals
	for key in BingoArray:
		for i in 5:
			var NumberInstance = NumberScene.instantiate()
			NumberInstance.Number = BingoArray[key][i]
			get_node("Split/Board/"+str(key)+"/VBoxContainer/NumberHolder").add_child(NumberInstance)

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

var FirstNNumber : int = 0

func _on_number_button_pressed() -> void:
	#gets called when a ball is drawn
	if BallCount >= 1:
		BallCount -= 1
		DrawnNumber.append(PossibleDraws[0])
		#adds a label to the numbers panel
		var BallLabelInst : Label = BallLabelScene.instantiate()
		BallLabelInst.text = convert_number_to_bingo_ball(PossibleDraws[0])
		$Split/InfoPanel/VBoxContainer/NumbersPanel.add_child(BallLabelInst)
		#Auto check thingy here
		if AutoSelect == true:
			for BoardButton : Button in get_tree().get_nodes_in_group("bingobutton"):
				bingo_button_pressed(BoardButton)
		#Chekcs for mid win
		if PossibleDraws[0] >= 31 and PossibleDraws[0] <= 45 and FirstNNumber == 0:
			FirstNNumber = PossibleDraws[0]
			if FirstNNumber == BingoArray["N"][2]:
				MidWin = true
			else:
				$Split/InfoPanel/VBoxContainer/HBoxContainer/Middle.get_theme_stylebox("panel").bg_color = Color.GRAY
		PossibleDraws.pop_front()
	if BallCount <= 0:
		$Split/InfoPanel/VBoxContainer/NumberButton.disabled = true
		if FullWin == false:
			$Split/InfoPanel/VBoxContainer/HBoxContainer/Full.get_theme_stylebox("panel").bg_color = Color.GRAY
	$Split/InfoPanel/VBoxContainer/BallCounter.text = "Balls left: %d" % (BallCount)
	check_game_state()
	if randi_range(1,1000) == 1:
		$Settings/AnimationPlayer.play("lobbster")


func _on_auto_select_toggled(toggled_on: bool) -> void:
	AutoSelect = toggled_on
	if AutoSelect == true:
		$Settings/Panel/VBoxContainer/AutoSelect.text = "Auto select squares: On"
	else:
		$Settings/Panel/VBoxContainer/AutoSelect.text = "Auto select squares: Off"


func _on_button_pressed() -> void:
	$Settings.visible = false
	if AutoSelect == true:
		#Goes through the all the buttons to check all of them.
		for Number in get_tree().get_nodes_in_group("bingobutton"):
			bingo_button_pressed(Number)



func _on_cheat_pressed() -> void:
	BallCount += 1
	var CatScene = preload("res://evil_cat.tscn")
	var CatInst = CatScene.instantiate()
	add_child(CatInst)
	$Split/InfoPanel/VBoxContainer/BallCounter.text = "Balls left: %d" % (BallCount)
