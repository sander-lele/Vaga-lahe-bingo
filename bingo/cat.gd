extends TextureRect

func _physics_process(delta: float) -> void:
	position += Vector2(randi_range(1,20),0).rotated(rotation)
	rotation = lerp_angle(rotation,global_position.angle_to_point(get_global_mouse_position()),0.05)


func _on_mouse_entered() -> void:
	get_tree().reload_current_scene()
