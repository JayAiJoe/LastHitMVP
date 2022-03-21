extends Control

signal input_sent(text)

const HISTORY_LENGTH := 20
var output_count := 0
var stats = []
onready var game_log: RichTextLabel = $Game
onready var line_edit: LineEdit = $Input

var buffer = ""

func _ready():
	stats = $StatsPanel/Stats.get_children()
	game_log.bbcode_text = ""

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
