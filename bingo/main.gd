extends Control

@export var NumberButton : Button
@export var BallCounter : Label
@export var NumbersLabel : Label

var NumberScene = preload("res://number.tscn")

var BallCount : int = 48
var DrawnNumber : Array = []
#These are the numbers in each letter
var BingoArray : Dictionary = {"B":[],"I":[],"N":[],"G":[],"O":[]} 

#These show the possible number range for each letter
var BingoArrayRange : Dictionary = {"B":range(1,16),"I":range(16,31),"N":range(31,46),"G":range(46,61),"O":range(61,76)}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_board()
	draw_board()
	reset_range_array()

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
	

func pick_random_number():
	var Num : int = randi_range(1,75)
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

func check_value_on_board(BoardResult : String):
	var BoardLetter : String = BoardResult[0]
	var BoardNumber : int = int(BoardResult.substr(1))
	DrawnNumber.append(BoardResult)
	if BoardNumber in BingoArray[BoardLetter]:
		print("yep")
	else:
		print("nah")

func _on_button_pressed() -> void:
	if BallCount >= 1:
		BallCount -= 1
		check_value_on_board(pick_random_number())
	else:
		$Split/InfoPanel/VBoxContainer/NumberButton.disabled = true
