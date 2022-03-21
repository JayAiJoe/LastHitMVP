extends Node2D


signal input_processed

onready var console = $Console

func _ready():
	console.connect("input_sent", self, "process_input")
	yield(get_info(), "completed")

func process_input(text : String):
	emit_signal("input_processed", text)

func get_info():
	console.print_output("Waiting for players...")
	for i in range(4):
		console.ask_input("Enter name")
		console.stats[i].set_name(yield(self, "input_processed"))
		console.stats[i].change_hp(100)
	console.ask_input("Type \"g\" to start")
	while(yield(self, "input_processed") != "g"):
		console.ask_input("Type \"g\" to start")
	console.print_output("Game Started!")
	

