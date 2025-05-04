extends Control

var rng : RandomNumberGenerator = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	$Background/TVBackground/BadNEWS.text = storage.Badnews
	$Background/TVBackground/GoodNEWS.text = storage.Goodnews
	storage.connect("news_changed", UpdateNews)
	
	if (!storage.TVTutorial or storage.TVTutorial == null):
		storage.TVTutorial = false
		tutorial()
	else:
		tutorialclear()

func tutorial():
	$TutorialPanel.visible = true

func tutorialclear():
	storage.TVTutorial = true
	$TutorialPanel.queue_free()
	
func UpdateNews():
	$Background/TVBackground/BadNEWS.text = storage.Badnews
	$Background/TVBackground/GoodNEWS.text = storage.Goodnews

func _input(event):
	if (event.is_action_pressed("Escape")):
		get_tree().change_scene_to_file("res://MainGame/main_game_bedroom.tscn")
	elif (event.is_action_pressed("LeftClick") and !storage.TVTutorial):
		tutorialclear()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_return_button_pressed():
	if storage.TVTutorial == true:
		get_tree().change_scene_to_file("res://MainGame/main_game_bedroom.tscn")
