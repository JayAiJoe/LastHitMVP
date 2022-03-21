extends "res://src/models/Character.gd"
class_name Player

var skills = []
var dicebag = []

func _ready():
	init_default()

func init_default():
	_atk = 10
	_max_hp = 30
	_hp = 30

func roll_dice():
	dicebag.clear()
	for d in range(5):
		var new_dice = Dice.new()
		dicebag.append(new_dice)
