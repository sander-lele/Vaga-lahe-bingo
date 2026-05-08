extends Control





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
	Global.SelfGen = true
	$AnimationPlayer.play("play")


func _on_play_back_pressed() -> void:
	$ButtonSets.play("set_normal")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match(anim_name):
		"play":
			get_tree().change_scene_to_file("res://main.tscn")
