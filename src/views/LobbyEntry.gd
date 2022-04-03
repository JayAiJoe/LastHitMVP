extends Panel


signal joined(lobby)

var _lobby


func set_lobby(lobby):
	_lobby = lobby
	$Label.text = lobby.name


func _on_Button_clicked(instance):
	if _lobby:
		emit_signal("joined", _lobby)
