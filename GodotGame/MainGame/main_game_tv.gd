extends Control

var rng : RandomNumberGenerator = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	Gamewatch_Increase()
	$Background/TVBackground/BadNEWS.text = storage.Badnews
	$Background/TVBackground/GoodNEWS.text = storage.Goodnews
	storage.connect("news_changed", UpdateNews)
	storage.connect("gamewatch_changed", Gamewatch_Increase)
	
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

func Gamewatch_Increase():
	var GameWatch = storage.GameWatch
	if GameWatch % 60 > 9:
			if int(GameWatch/60) > 9:
				$GameTimer.text = str(int(GameWatch/60)) + ":" + str(GameWatch % 60)
			else:
				$GameTimer.text = "0" + str(int(GameWatch/60)) + ":" + str(GameWatch % 60)
	else:
		if int(GameWatch/60) > 9:
			$GameTimer.text = str(int(GameWatch/60)) + ":0" + str(GameWatch % 60)
		else:
			$GameTimer.text = "0" + str(int(GameWatch/60)) + ":0" + str(GameWatch % 60)

func _on_return_button_pressed():
	if storage.TVTutorial == true:
		get_tree().change_scene_to_file("res://MainGame/main_game_bedroom.tscn")
