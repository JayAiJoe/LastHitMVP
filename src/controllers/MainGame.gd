extends Node2D


signal input_processed

onready var console = $Console

var enemy = null
var players = []
var turn_token = -1
var player_colors = ["red", "orange", "yellow", "blue"]
var player_count = 2

func _ready():
	console.connect("input_sent", self, "process_input")
	yield(get_info(), "completed")
	prep_encounter()
	yield(run_encounter(), "completed")

func process_input(text : String):
	emit_signal("input_processed", text)

func get_info():
	console.print_output("Waiting for players...")
	for i in range(player_count):
		console.ask_input("Enter name")
		var name = yield(self, "input_processed")
		var new_player = Player.new() 
		new_player.set_display_name(name)
		players.append(new_player)
		console.add_character(new_player)
	console.ask_input("Type \"g\" to start")
	while(yield(self, "input_processed") != "g"):
		console.ask_input("Type \"g\" to start")
	console.print_output("Game Started!")
	
func prep_encounter():
	enemy = Enemy.new()
	enemy.set_display_name("OwO")
	console.add_character(enemy)
	turn_token = 0
	for p in players:
		p.roll_dice()
	
func run_encounter():
	while enemy.get_hp() > 0:
		yield(get_player_action(players[turn_token]), "completed")
		turn_token = (turn_token+1)%(player_count)
	console.print_output("Enemy Defeated")
	
func get_player_action(player : Player):
	console.print_output("\n[color=" + Palette.Colors[player_colors[turn_token]] +"]" + player.get_display_name() + "'s turn:[/color]")
	var dice_text = "Dice:"
	var dice_values = []
	for d in player.dice_bag:
		dice_text += " " + str(d.get_value())
		dice_values.append(d.get_value())
	console.print_output(dice_text)
	
	for s in player.skills:
		console.print_output(s + "X - " +  Actions.skills[player.skills[s]]["name"])
		
	console.ask_input("Enter Action")
	var action : String = yield(self, "input_processed")
	var choice : String = action[0]
	var die : int = action.right(1) as int
	while not choice in ["a", "b", "c", "d"] or not die in dice_values:
		console.ask_input("Enter Action")
		action = yield(self, "input_processed")
		choice = action[0]
		die = action.right(1) as int
	
	console.print_output("[color=" + Palette.Colors[player_colors[turn_token]] +"]" +player.get_display_name() + "[/color]" + " used " + Actions.skills[player.skills[choice]]["name"])
	perform_action(player, choice, die)

func perform_action(player: Player, choice : String, die : int):
	player.consume_die(die)
	console.add_action(player, die)
	var code = player.skills[choice]
	for component in Actions.skills[code]["components"]:
		match(component["type"]):
			Actions.Types.DEAL_DAMAGE:
				var dmg = 0
				if component["value"]  == Actions.SCALE_ATK:
					 dmg = player.get_atk()
				else:
					dmg = component["value"]
				var target : Character
				target = enemy
				target.receive_dmg(dmg)
				break
			Actions.Types.BUFF_ATTACK:
				player.set_atk(player.get_atk() + component["value"])
			Actions.Types.HEAL_HP:
				player.add_to_hp(component["value"])
			Actions.Types.GAIN_SHIELD:
				player.add_to_shield(component["value"])
