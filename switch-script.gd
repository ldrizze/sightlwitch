extends Node2D

@export var on: bool = false

func switch():
	if on:
		$Sprite2D.play("off")
		on = false
	else:
		$Sprite2D.play("on")
		on = true
