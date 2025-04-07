extends Control

@onready var single_ton = storage

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	$Background/TVBackground/BadNEWS.text = storage.Badnews
	$Background/TVBackground/GoodNEWS.text = storage.Goodnews
	storage.connect("news_changed", UpdateNews)
	
func UpdateNews():
	$Background/TVBackground/BadNEWS.text = storage.Badnews
	$Background/TVBackground/GoodNEWS.text = storage.Goodnews

func _input(event):
	if (event.is_action_pressed("Escape")):
		get_tree().change_scene_to_file("res://main_game_bedroom.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
