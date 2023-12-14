extends Node2D

func _ready():
	LightSwitchController.reload()
	LightSwitchController.blue()

func next_level():
	get_tree().change_scene_to_file("res://levels/level_2.tscn")

func _on_timer_timeout():
	next_level()
