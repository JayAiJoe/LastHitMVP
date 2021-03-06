extends "res://src/models/Character.gd"
class_name Player

var skills = { "a" : 0, "b" : 0, "c" : 0, "d" : 0}
var dice_max = 6
var dice_bag = []
var color = "blue"
var score = 0

func _init():
	_atk = 20
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
		
func get_dice_values() -> Array:
	var values = []
	for d in dice_bag:
		values.append(d.get_value())
	return values

func assign_skill(slot : String, skill_code : int):
	if slot == "a" or slot == "b" or slot == "c":
		skills[slot] = skill_code

func consume_die(value : int):
	for d in dice_bag:
		if d.get_value() == value:
			dice_bag.erase(d)
			break

func get_color() -> String:
	return color
	
func set_color(clr : String):
	color = clr

func get_score():
	return score
	
func add_to_score(points : int):
	score += points
