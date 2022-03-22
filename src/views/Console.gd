extends Control

signal input_sent(text)

const HISTORY_LENGTH := 20

var Stat_display = preload("res://src/views/StatDisplay.tscn")
var Action_display = preload("res://src/views/ActionDisplay.tscn")
var output_count := 0
var stats = []
onready var game_log: RichTextLabel = $Game
onready var line_edit: LineEdit = $Input
onready var stats_list : VBoxContainer = $StatsPanel/Stats
onready var action_stack : VBoxContainer = $StackPanel/Stack

var buffer = ""

func _ready():
	
	game_log.bbcode_text = ""

func add_action(c : Character, d : int):
	var ad = Action_display.instance()
	action_stack.add_child(ad)
	action_stack.move_child(ad, 0)
	ad.write(c,d)

func add_character(c : Character):
	var sd = Stat_display.instance()
	stats_list.add_child(sd)
	sd.set_name(c.get_display_name()) 
	sd.change_hp(c.get_hp())
	stats.append(sd)
	c.connect("hp_changed", sd, "change_hp")
	c.connect("shield_changed", sd, "change_shield")
	
	
func print_output(text: String):
	game_log.bbcode_text += ("\n" + text)

func ask_input(text: String):
	line_edit.append_at_cursor(text + ": ")
	

func _on_Input_text_entered(new_text):
	new_text = new_text.split(": ")[-1]
	line_edit.text = ""
	if new_text.length() == 0:
		return
	emit_signal("input_sent", new_text)
