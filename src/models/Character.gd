extends Node
class_name Character

signal hp_changed
signal shield_changed
signal died

var _initiative = 0
var _atk = 0
var _max_hp = 0
var _shield = 0
var _hp = 0 
var _display_name = ""

var statuses = {}

#passives
var encounter_start_effects = []
var encounter_end_effects = []
var turn_start_effects = []
var turn_end_effects = []
var hit_enemy_effects = []
var get_hit_effects = []
var gain_shield_effects = []
var gain_heal_effects = []

var last_hit_by : Character

func _ready():
	pass # Replace with function body.

func _no_set(val):
	pass

func set_initiative(i : int):
	_initiative = i

func set_atk(a : int):
	_atk = a
	
func set_shield(s : int):
	_shield = s
	signal_shield_changed()

func set_max_hp(mhp : int):
	_max_hp = mhp

func set_hp(hp : int):
	_hp = hp
	signal_hp_changed()

func set_display_name(nm : String):
	_display_name = nm

func get_initiative() -> int:
	return _initiative

func get_atk() -> int:
	var temp_atk = _atk
	if Actions.Status.STRENGTH in statuses:
		temp_atk += statuses[Actions.Status.STRENGTH]["stacks"]
	if Actions.Status.WEAK in statuses:
		temp_atk -= statuses[Actions.Status.WEAK]["stacks"]
	return int(max(0, temp_atk))

func get_max_hp() -> int:
	return _max_hp

func get_hp() -> int:
	return _hp

func get_shield() -> int:
	return _shield

func get_display_name() -> String:
	return _display_name
	
func add_to_hp(val : int):
	_hp += val
	signal_hp_changed()

func receive_dmg(val : int):
	var true_dmg = val-_shield
	_shield = max(0, _shield-val)
	signal_shield_changed()
	if true_dmg > 0:
		_hp -= true_dmg
		signal_hp_changed()
	if _hp <= 0:
		signal_death()
		
func add_to_atk(a : int):
	_atk += a
	
func add_to_shield(val: int):
	_shield += val
	signal_shield_changed()

func signal_hp_changed():
	emit_signal("hp_changed", _hp)

func signal_shield_changed():
	emit_signal("shield_changed", _shield)

func signal_death():
	emit_signal("died", self)

func gain_condition(condition : String, stack : int, giver : Character):
	if condition in statuses:
		statuses[condition]["stacks"] += stack
	else:
		statuses[condition] = {"stacks":stack, "giver":giver}

func reset_conditions():
	statuses = {}
		
func trigger_turn_conditions():
	receive_dmg(statuses[Actions.Status.POISON]["stacks"])
