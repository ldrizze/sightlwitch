extends StaticBody2D

@export var flying_points: Array[Marker2D]
@export var wait_time_after_land: float = 3
@export var between_duration: float = 1
@export var repeat: bool = true
@export var inverted_direction = false

var _tw: Tween
var _direction: bool = false
var _ar: Array

func _ready():
	if len(flying_points) > 0:
		position = flying_points[0].position
		_copy_arr()
		create_bat_tween()

func _copy_arr():
	for m in flying_points:
		_ar.append(m)
	_ar.reverse()

func create_bat_tween():
	_tw = create_tween()
	$Sprite.play("flying")
	$Sprite.flip_h = !inverted_direction
	var c = 0
	for m in (flying_points if !_direction else _ar):
		if c < 1:
			c += 1
			continue

		var marker = m as Marker2D
		_tw.tween_property(self, "position", marker.position, between_duration)

	if wait_time_after_land > 0:
		_direction = !_direction
		inverted_direction = !inverted_direction
		_tw.tween_interval(wait_time_after_land)
	
	_tw.connect("step_finished", _anim_step_finished)
	await _tw.finished
	
	# Call deferred cuz stackoverflow
	if repeat:
		call_deferred("create_bat_tween")

func _anim_step_finished(step: int):
	var last_step = len(flying_points) - 2
	if step == last_step:
		$Sprite.play("idle")
