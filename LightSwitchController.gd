extends Node

signal on_switch

var _actual: bool = false
var _reds: Array = []
var _blues: Array = []

func _ready():
	var items = get_tree().root.get_node("/root/main/Map").get_children()
	var mps = get_tree().root.get_node("/root/main/Map/MPS")
	if mps != null:
		for c in mps.get_children():
			items.push_back(c)

	for c in items:
		if c.is_in_group("red"):
			_reds.push_front(c)
			
		if c.is_in_group("blue"):
			_blues.push_front(c)

	switch()

func blue():
	_actual = false
	switch()

func red():
	_actual = true
	switch()

func switch():
	if _actual:
		for b in _blues:
			if b != null:
				b.show()

		for r in _reds:
			if r != null:
				r.hide()
	else:
		for b in _blues:
			if b != null:
				b.hide()

		for r in _reds:
			if r != null:
				r.show()

	_actual = !_actual
	emit_signal("on_switch")

func reset():
	_actual = false
	switch()

func reload():
	_ready()
