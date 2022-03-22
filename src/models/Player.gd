extends "res://src/models/Character.gd"
class_name Player

var skills = { "a" : 0, "b" : 0, "c" : 0, "d" : 0}
var dice_max = 5
var dice_bag = []

func _init():
	_atk = 10
	_max_hp = 30
	_hp = 30
	assign_skill("a", Actions.Skill_codes.FIREBALL)
	assign_skill("b", Actions.Skill_codes.RAGE)
	assign_skill("c", Actions.Skill_codes.MINOR_HEALING)

func roll_dice():
	dice_bag.clear()
	for d in range(dice_max):
		var new_dice = Dice.new()
		dice_bag.append(new_dice)

func assign_skill(slot : String, skill_code : int):
	if slot == "a" or slot == "b" or slot == "c":
		skills[slot] = skill_code

func consume_die(value : int):
	for d in dice_bag:
		if d.get_value() == value:
			dice_bag.erase(d)
			break
