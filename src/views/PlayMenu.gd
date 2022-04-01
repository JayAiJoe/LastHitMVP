extends Control


signal clicked(action)

var min_players = 2

func _ready():
	$Panel/Lobby.hide()
	$Panel/Lobby/Play.set_disabled(true)


func _on_Host_clicked(instance):
	emit_signal("clicked", "host")
	show_lobby()


func _on_Join_clicked(instance):
	emit_signal("clicked", "join")
	show_lobby()
	
func show_lobby():
	$Panel/Lobby.show()

func update_match():
	var count = Multiplayer.get_all_player_info().size()
	$Panel/Lobby/Connected.text = str(count) + " in match"
	var names_text = ""
	for n in Multiplayer.get_all_player_info():
		names_text += str(Multiplayer.get_player_info(n)["name"]) + "    "
	$Panel/Lobby/Names.text = names_text
	if count >= min_players:
		$Panel/Lobby/Play.set_disabled(false)
	

func _on_Play_clicked(instance):
	emit_signal("clicked", "start")

func _on_Back_clicked(instance):
	emit_signal("clicked", "leave")
	$Panel/Lobby.hide()
