extends Node

var names = ["Amber", "Eula", "Rosaria", "Ei", "Venti", "Ningguang", "Zhongli", "Jean"]

var _name
var _color

var my_info = {}
var player_info = {}

const PORT = 8070
var peer = null

func _init():
	randomize()
	var n = randi()%names.size()
	my_info = {"name" : names[n]}
	
func reset_multiplayer_info():
	player_info = {}
	
func init_match():
	player_info = {1:my_info}
	
func update_players(host_player_list):
	player_info = host_player_list

func get_all_player_info():
	return player_info
	
func get_player_info(id):
	return player_info[id]

func get_my_info():
	return my_info
