extends Control





func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_guide_button_pressed() -> void:
	$GuidePanel.visible = true


func _on_guide_close_pressed() -> void:
	$GuidePanel.visible = false
