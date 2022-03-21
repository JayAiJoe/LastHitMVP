extends Node
class_name Dice

var _value = 0

func _ready():
	roll()

func roll() -> int:
	randomize()
	_value = randi()%20 + 1
	return _value

func set_value(d : int):
	_value = d

func get_value() -> int:
	return _value
