extends Node2D

const PORT = 8070
var peer = null

var closing = false

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")


func _on_PlayMenu_clicked(action):
	match(action):
		"host":
			host()
		"join":
			join()
		"leave":
			leave_match()
		"start":
			start_match()
		


func host():
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT)
	get_tree().set_network_peer(peer)
	
	Multiplayer.init_match()
	$PlayMenu.update_match()

func join():
	peer = NetworkedMultiplayerENet.new()
	peer.create_client("127.0.0.1", PORT)
	get_tree().set_network_peer(peer)
	yield(get_tree(), "connected_to_server")
	

remote func host_kick():
	peer.close_connection()
	Multiplayer.reset_multiplayer_info()
	$PlayMenu/Panel/Lobby.hide()

func leave_match():
	if get_tree().get_network_unique_id() == 1:
		rpc("host_kick")
		closing = true
	else:
		peer.close_connection()
		Multiplayer.reset_multiplayer_info()

func start_match():
	print("started")

func _player_connected(id):
	rpc_id(id, "send_player_info")

func _player_disconnected(id):
	Multiplayer.get_all_player_info().erase(id)
	rpc("update_match", Multiplayer.get_all_player_info())
	if Multiplayer.get_all_player_info().size() <= 1 and closing:
		Multiplayer.reset_multiplayer_info()
		peer.close_connection()
		closing = false
	
remotesync func update_match(host_player_list):
	Multiplayer.update_players(host_player_list)
	$PlayMenu.update_match()
	
remote func send_player_info():
	rpc_id(1, "retrieve_player_info", Multiplayer.get_my_info())

remote func retrieve_player_info(info):
	var id = get_tree().get_rpc_sender_id()
	Multiplayer.get_all_player_info()[id] = info
	rpc("update_match", Multiplayer.get_all_player_info())


