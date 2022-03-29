extends "res://src/models/Character.gd"
class_name Enemy

var points = 0
var drop_code = 0

func _init():
	_atk = 10
	_max_hp = 50
	_hp = 50
	_initiative = 10
	points = 3
	drop_code = Actions.Skill_codes.FIREBALL

func get_points() -> int:
	return points

func get_drop_code() -> int:
	return drop_code
