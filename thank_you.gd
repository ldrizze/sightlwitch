extends Node2D


func _on_button_back_pressed():
	get_tree().change_scene_to_file("res://start.tscn")


func _on_button_play_again_pressed():
	get_tree().change_scene_to_file("res://levels/level_1.tscn")
