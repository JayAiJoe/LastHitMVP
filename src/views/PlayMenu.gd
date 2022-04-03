extends Control


signal clicked(action)

var min_players = 2

onready var m_match = $Panel/Match
onready var m_lobby = $Panel/Lobby

func _ready():
	m_match.get_node("Play").set_disabled(true)
	hide_all()

func _on_Host_clicked(instance):
	emit_signal("clicked", "host")
	show_match()
	
func show_match():
	m_lobby.hide()
	update_match()
	m_match.show()

func show_lobby():
	m_match.hide()
	m_lobby.show()

func hide_all():
	m_lobby.hide()
	m_match.hide()
	
func update_match():
	var count = Multiplayer.get_all_player_info().size()
	m_match.get_node("Connected").text = str(count) + " in match"
	var names_text = ""
	for n in Multiplayer.get_all_player_info():
		names_text += str(Multiplayer.get_player_info(n)["name"]) + "    "
	m_match.get_node("Names").text = names_text
	if count >= min_players:
		m_match.get_node("Play").set_disabled(false)
	

func _on_Play_clicked(instance):
	emit_signal("clicked", "start")

func _on_Back_clicked(instance):
	hide_all()


func _on_JoinLobby_clicked(instance):
	emit_signal("clicked", "refresh")
	show_lobby()
	

func _on_Leave_clicked(instance):
	emit_signal("clicked", "leave")
	hide_all()


func _on_Refresh_clicked(instance):
	emit_signal("clicked", "refresh")
