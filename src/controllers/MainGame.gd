extends Node2D


signal input_processed

onready var console = $Console

var enemy = null
var players = []
var characters = []
var turn_token = -1
var player_colors = ["red", "orange", "yellow", "blue"]
var player_count = 1
var character_count = 0

var last_hit : Player = null

func _ready():
	console.connect("input_sent", self, "process_input")
	yield(get_info(), "completed")
	yield(prep_campaign(), "completed")
	for i in range(9):
		yield(prep_encounter(), "completed")
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
		new_player.set_color(player_colors[i])
		players.append(new_player)
		characters.append(new_player)
		console.add_character(new_player)
	console.ask_input("Type \"g\" to start")
	while(yield(self, "input_processed") != "g"):
		console.ask_input("Type \"g\" to start")
	console.print_output("Game Started!")

func prep_campaign():
	randomize()
	for p in players:
		console.print_output("\n[color=" + Palette.Colors[p.get_color()] +"]" + p.get_display_name() + ", choose your starters (3):[/color]")
		var skill_text = "Skills:"
		var choices = Utils.sample(Actions.Skill_codes.values().slice(1,-1), 5)
		choices.sort()
		for s in choices:
			skill_text += "\n " + str(s) + " - " + Actions.get_skill_details(s)
		console.print_output(skill_text)
		var ctr = 0
		var code : int
		var chosen = []
		while(ctr < 3):
			console.ask_input("Enter code")
			code = yield(self, "input_processed") as int
			if code in choices and not code in chosen:
				chosen.append(code)
				p.assign_skill(char(97+ctr), code)
				ctr += 1
		p.connect("died", self, "handle_player_death")
		
		
func prep_encounter():
	enemy = Enemy.new()
	enemy.set_display_name("OwO")
	characters.append(enemy)
	console.add_character(enemy)
	turn_token = 0
	for p in players:
		p.roll_dice()
		yield(get_player_initiative(p), "completed")
	characters.sort_custom(Utils, "sort_initiative")
	character_count = characters.size()
	last_hit = null
		
func get_player_initiative(player : Player):
	console.print_output("\n[color=" + Palette.Colors[player.get_color()] +"]" + player.get_display_name() + "'s initiative roll:[/color]")
	var dice_text = "Dice:"
	var dice_values = player.get_dice_values()
	for d in dice_values:
		dice_text += " " + str(d)
	console.print_output(dice_text)
	console.ask_input("Enter Initiative")
	var initiative : int = yield(self, "input_processed") as int
	while not initiative in dice_values:
		console.ask_input("Enter Initiative")
		initiative = yield(self, "input_processed") as int
	player.set_initiative(initiative)
	player.consume_die(initiative)
	
func run_encounter():
	while enemy.get_hp() > 0:
		var current_character = characters[turn_token]
		if current_character is Player:
			if current_character.get_hp() > 0: 
				yield(get_player_action(current_character), "completed")
		else:
			perform_enemy_action(current_character)
		current_character.trigger_turn_conditions()
		turn_token = (turn_token+1)%(character_count)
	yield(end_encounter(), "completed")
		
func end_encounter():
	if last_hit != null:
		last_hit.add_to_score(enemy.get_points())
		yield(reward_player(last_hit, enemy.get_drop_code()), "completed")
	console.remove_enemy()
	console.print_output("\nEnemy Defeated!")
	for p in players:
		p.reset_conditions()
		console.print_output(p.get_display_name() + " - " + str(p.get_score()))
		
func handle_player_death(player : Player):
	console.print_output("\n[color=" + Palette.Colors[player.get_color()] +"]" + player.get_display_name() + " died[/color]")
	var index = players.find(player)
	console.remove_player(index)
	players.erase(player)
	characters.erase(player)
	player_count = players.size()
	character_count = characters.size()
	turn_token = (turn_token)%(character_count)
	player.queue_free()

func reward_player(winner : Player, skill_code : int):
	console.print_output("\n[color=" + Palette.Colors[winner.get_color()] +"]" + winner.get_display_name() + ", learn new skill: " + Actions.skills[skill_code]["name"] + "?[/color]")
	console.print_output("1 - replace skill 1")
	console.print_output("2 - replace skill 2")
	console.print_output("3 - replace skill 3")
	console.print_output("4 - skip")
	console.ask_input("Choice")
	var choice = yield(self, "input_processed") as int
	while not (choice >=1 and choice <=4):
		choice = yield(self, "input_processed") as int
	if choice != 4:
		winner.assign_skill(char(96 + choice), skill_code)
		
	
func get_player_action(player : Player):
	console.print_output("\n[color=" + Palette.Colors[player.get_color()] +"]" + player.get_display_name() + "'s turn:[/color]")
	var dice_text = "Dice:"
	var dice_values = player.get_dice_values()
	for d in dice_values:
		dice_text += " " + str(d)
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
	
	console.print_output("[color=" + Palette.Colors[player.get_color()] +"]" +player.get_display_name() + "[/color]" + " used " + Actions.skills[player.skills[choice]]["name"])
	perform_player_action(player, choice, die)

func perform_player_action(player: Player, choice : String, die : int):
	player.consume_die(die)
	console.add_action(player, die)
	var code = player.skills[choice]
	for component in Actions.skills[code]["components"]:
		match(component["type"]):
			Actions.Types.DEAL_DAMAGE:
				var dmg = 0
				match(component["value"]):
					Actions.SCALE_ATK:
						dmg = player.get_atk()
					Actions.SCALE_SHIELD:
						dmg = player.get_shield()
					_:
						dmg = component["value"]
				var target : Character
				target = enemy
				target.receive_dmg(dmg)
				last_hit = player
			Actions.Types.BUFF_ATTACK:
				player.gain_condition("strength", component["value"])
			Actions.Types.HEAL_HP:
				player.add_to_hp(component["value"])
			Actions.Types.GAIN_SHIELD:
				player.add_to_shield(component["value"])
			Actions.Types.APPLY_POISON:
				var target: Character = enemy
				last_hit = player
				target.gain_condition("poison", component["value"])
				

func perform_enemy_action(enemy : Enemy):
	var target = players[randi() % players.size()]
	console.print_output("\n" + enemy.get_display_name() + " attacked " + "[color=" + Palette.Colors[target.get_color()] +"]" + target.get_display_name() + "[/color]")
	target.receive_dmg(enemy.get_atk())
