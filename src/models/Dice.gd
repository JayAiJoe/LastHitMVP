extends Node
class_name Dice

var value = 0

func _init():
	roll()

func roll() -> int:
	randomize()
	value = randi()%20 + 1
	return value

func set_value(d : int):
	value = d

func get_value() -> int:
	return value
