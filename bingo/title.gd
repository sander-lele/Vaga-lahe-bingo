extends Control





func _on_play_button_pressed() -> void:
	$AnimationPlayer.play("set_play")


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_guide_button_pressed() -> void:
	$GuidePanel.visible = true


func _on_guide_close_pressed() -> void:
	$GuidePanel.visible = false


func _on_play_random_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_play_self_pressed() -> void:
	pass # Replace with function body.


func _on_play_back_pressed() -> void:
	$AnimationPlayer.play("set_normal")
