extends Node2D


onready var _fetch = GotmLobbyFetch.new()

var LobbyEntry = preload("res://src/views/LobbyEntry.tscn")

func _ready():
	Gotm.connect("lobby_changed", self, "_on_Gotm_lobby_changed")
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")


func _on_PlayMenu_clicked(action):
	match(action):
		"host":
			host()
		"leave":
			leave_match()
		"start":
			start_match()
		"refresh":
			yield(refresh_lobbies(), "completed")
		


func host():
	Multiplayer.peer = NetworkedMultiplayerENet.new()
	var res = Multiplayer.peer.create_server(Multiplayer.PORT)
	if res == OK:
		get_tree().set_network_peer(Multiplayer.peer)
		Gotm.host_lobby(false)
		Gotm.lobby.hidden = false
		Gotm.lobby.name = Multiplayer.get_my_info()["name"] + "'s game"
	
	Multiplayer.init_match()
	$PlayMenu.update_match()

func join(lobby):
	var success = yield(lobby.join(), "completed")
	if success:
		Multiplayer.peer = NetworkedMultiplayerENet.new()
		Multiplayer.peer.create_client(Gotm.lobby.host.address, Multiplayer.PORT)
		get_tree().set_network_peer(Multiplayer.peer)
		yield(get_tree(), "connected_to_server")
		$PlayMenu.show_match()
	else:
		push_error("Failed to connect to lobby '" + lobby.name + "'!")
	

remote func host_kick():
	#get_tree().network_peer.disconnect_peer(get_tree().get_network_unique_id())
	#Multiplayer.peer.close_connection()
	Multiplayer.reset_multiplayer_info()
	$PlayMenu.hide_all()
	
func close_server():
	for i in Multiplayer.get_all_player_info():
		if i != 1:
			print("kicked " + str(i))
			rpc_id(i,"host_kick")
			get_tree().network_peer.disconnect_peer(i)
	Multiplayer.reset_multiplayer_info()
	#Multiplayer.peer.close_connection()
	get_tree().set_network_peer(null)
	Gotm.lobby.hidden = true


func leave_match():
	if get_tree().get_network_unique_id() == 1:
		close_server()
	else:
		get_tree().network_peer.disconnect_peer(get_tree().get_network_unique_id())
		Multiplayer.peer.close_connection()
		Multiplayer.reset_multiplayer_info()

func start_match():
	print("started")

func _player_connected(id):
	rpc_id(id, "send_player_info")

func _player_disconnected(id):
	Multiplayer.get_all_player_info().erase(id)
	rpc("update_match", Multiplayer.get_all_player_info())
	
remotesync func update_match(host_player_list):
	Multiplayer.update_players(host_player_list)
	$PlayMenu.update_match()
	
remote func send_player_info():
	rpc_id(1, "retrieve_player_info", Multiplayer.get_my_info())

remote func retrieve_player_info(info):
	var id = get_tree().get_rpc_sender_id()
	Multiplayer.get_all_player_info()[id] = info
	rpc("update_match", Multiplayer.get_all_player_info())

func refresh_lobbies():
	var lobby_list = $PlayMenu/Panel/Lobby/List
	for child in lobby_list.get_children():
		child.queue_free()
	
	var lobbies = yield(_fetch.first(3), "completed")
	
	for i in range(lobbies.size()):
		var lobby = lobbies[i]
		var node = LobbyEntry.instance()
		node.connect("joined", self, "join")
		node.show()
		lobby_list.add_child(node)
		node.set_lobby(lobby)
	
func _on_Gotm_lobby_changed():
	if not Gotm.lobby:
		$PlayMenu.hide_all()


