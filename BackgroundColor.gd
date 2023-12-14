extends Node2D

var _last_color_draw: bool = false

func _ready():
	_last_color_draw = LightSwitchController._actual

func _process(_delta):
	if _last_color_draw != LightSwitchController._actual:
		queue_redraw()
		_last_color_draw = LightSwitchController._actual

func _draw():
	if LightSwitchController._actual:
		draw_rect(Rect2(0, 0, 640, 360), Color.hex(0x6166ffff))
	else:
		draw_rect(Rect2(0, 0, 640, 360), Color.hex(0xff5454ff))
