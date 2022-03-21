extends "res://src/models/Character.gd"
class_name Enemy


func _ready():
	init_default()

func init_default():
	_atk = 3
	_max_hp = 50
	_hp = 50
