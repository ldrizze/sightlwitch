extends Node2D

@export var init: Marker2D
@export var end: Marker2D
@export var duration: float = 3.0

var _direction = true
var _tw: Tween

func _ready():
	if init == null or end == null:
		print("Markers not set")
	else:
		position = init.position
		_tw = create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		_tw.set_loops()
		_tw.tween_property(self, "position", end.position, duration)
		_tw.tween_property(self, "position", init.position, duration)
		#_tween_end()
	
func _tween_end():
	_tw = create_tween()
	_direction = !_direction

	if _direction:
		_tw.tween_property(self, "position", init.position, duration)
	else:
		_tw.tween_property(self, "position", end.position, duration)
		
	_tw.tween_callback(_tween_end)
