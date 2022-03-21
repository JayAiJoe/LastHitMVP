extends Node
class_name Character

signal hp_changed

var _initiative = 0
var _atk = 0
var _max_hp = 0
var _hp = 0 setget signal_hp_changed
var _display_name = ""


func _ready():
	pass # Replace with function body.

func set_initiative(i : int):
	_initiative = i

func set_atk(a : int):
	_atk = a

func set_max_hp(mhp : int):
	_max_hp = mhp

func set_hp(hp : int):
	_hp = hp

func set_display_name(nm : String):
	_display_name = nm

func get_initiative() -> int:
	return _initiative

func get_atk() -> int:
	return _atk

func get_max_hp() -> int:
	return _max_hp

func get_hp() -> int:
	return _hp

func get_display_name() -> String:
	return _display_name
	
func add_to_hp(val : int):
	_hp += val

func signal_hp_changed(val):
	emit_signal("hp_changed", val)
