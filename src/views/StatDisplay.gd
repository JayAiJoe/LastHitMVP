extends MarginContainer


onready var hp_bar = $VBox/ProgressBar
onready var tween = $Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func change_hp(new_hp : int):
	var old_hp = hp_bar.value  
	tween.interpolate_property(hp_bar, "value", old_hp, new_hp, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func set_name(name : String):
	$VBox/Label.text = name.substr(0, 15)
