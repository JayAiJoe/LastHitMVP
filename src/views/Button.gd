extends Panel

signal clicked(instance)
export(String) var text = "Text" setget set_text

var disabled = false

func _ready():
	pass


func set_text(new_text):
	text = new_text
	$Label.text = text

func set_disabled(val : bool):
	disabled = val
	if disabled:
		modulate = Color.white * 0.5
	else:
		modulate = Color.white

func _on_Button_mouse_exited():
	if not disabled:
		modulate = Color.white

func _on_Button_mouse_entered():
	if not disabled:
		modulate = Color.yellow * 0.9


func _on_Button_gui_input(event):
	if not disabled and event is InputEventMouseButton:
		if event.pressed:
			modulate = Color.white * 0.7
		else:
			_on_Button_mouse_entered()
			emit_signal("clicked", self)
