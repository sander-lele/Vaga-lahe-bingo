extends Control

var SelfChoiceScene = preload("res://self_choose.tscn")

@export var ErrorLabel : Label

func _ready() -> void:
	for button : Button in get_tree().get_nodes_in_group("button"):
		button.pressed.connect(button_pressed)
		button.mouse_entered.connect(button_hover.bind(button))

func button_pressed():
	$Sounds/Select.play()

func button_hover(Inst : Button):
	if Inst.disabled == false:
		$Sounds/Hover.play()

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


func _on_play_button_pressed() -> void:
	$ButtonSets.play("set_play")


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_guide_button_pressed() -> void:
	$GuidePanel.visible = true


func _on_guide_close_pressed() -> void:
	$GuidePanel.visible = false


func _on_play_random_pressed() -> void:
	Global.SelfGen = true
	$AnimationPlayer.play("play")


func _on_play_self_pressed() -> void:
	$ButtonSets.play("set_self")


func _on_play_back_pressed() -> void:
	$ButtonSets.play("set_normal")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match(anim_name):
		"play":
			get_tree().change_scene_to_file("res://main.tscn")


func _on_self_insert_text_submitted(new_text: String) -> void:
	ErrorLabel.visible = false
	if new_text.is_valid_int():
		var Num : int = int(new_text)
		convert_number_to_bingo_ball(Num)
		if (Num in Global.SelectedValues) == false:
			if Global.SelectedValues.size() < 8:
				if Num in range(1,76):
					Global.SelectedValues.append(Num)
					var Inst : Panel = SelfChoiceScene.instantiate()
					Inst.text = convert_number_to_bingo_ball(Num)
					Inst.remove_self.connect(remove_self.bind(Num))
					$VBoxContainer/ButtonSets/Self/PanelHolder.add_child(Inst,0)
					$VBoxContainer/ButtonSets/Self/SelfPlay.disabled = false
				else:
					ErrorLabel.visible = true
					ErrorLabel.text = "Value has to be in the range 1 to 75."
			else:
				ErrorLabel.visible = true
				ErrorLabel.text = "You can only add a total of 8 balls."
		else:
			ErrorLabel.visible = true
			ErrorLabel.text = "Value already exists."
	else:
		ErrorLabel.visible = true
		ErrorLabel.text = "Value has to be an integer."
	$VBoxContainer/ButtonSets/Self/SelfInsert.text = ""

func remove_self(Inst : Panel,Num : int):
	Global.SelectedValues.erase(Num)
	Inst.queue_free()
	if Global.SelectedValues.size() <= 0:
		$VBoxContainer/ButtonSets/Self/SelfPlay.disabled = true


func _on_self_play_pressed() -> void:
	Global.SelfGen = true
	$AnimationPlayer.play("play")


func _on_self_back_pressed() -> void:
	$ButtonSets.play("set_play")
