extends Control


var MusicBus = null
var SoundBus = null
func _ready():
	MusicBus = AudioServer.get_bus_index("Music")
	SoundBus = AudioServer.get_bus_index("SFX")


func _on_settings_pressed() -> void:
	visible = true





func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MusicBus,value)


func _on_sound_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(SoundBus,value)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "menu":
		get_tree().change_scene_to_file("res://title.tscn")
	elif  anim_name == "retry":
		get_tree().reload_current_scene()


func _on_retry_pressed() -> void:
	$AnimationPlayer.play("retry")


func _on_menu_pressed() -> void:
	$AnimationPlayer.play("menu")
