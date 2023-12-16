extends Node2D

func _ready():
	LightSwitchController.reload()
	LightSwitchController.blue()

func _on_next_scene_timer_timeout():
	next_level()

func next_level():
	get_tree().change_scene_to_file("res://levels/level_12.tscn")
