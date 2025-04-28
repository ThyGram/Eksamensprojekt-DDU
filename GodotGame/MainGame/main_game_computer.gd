extends Control

@onready var single_ton = storage

func _ready():
	Gamewatch_Increase()
	storage.connect("gamewatch_changed", Gamewatch_Increase)
	
	if (!storage.ComputerTutorial or storage.ComputerTutorial == null):
		tutorial()
	else:
		tutorialclear()
	

func tutorial():
	$TutorialPanel.visible = true

func tutorialclear():
	$TutorialPanel.queue_free()
	$TutorialTimer.start()

func _input(event):
	if (event.is_action_pressed("Escape")):
		get_tree().change_scene_to_file("res://MainGame/main_game_bedroom.tscn")
	elif (event.is_action_pressed("LeftClick") and $TutorialPanel != null) :
		tutorialclear()

func _on_calender_pressed():
	if storage.ComputerTutorial == true:
		get_tree().change_scene_to_file("res://MainGame/Computer/computer_calender.tscn")

func _on_stocks_pressed():
	if storage.ComputerTutorial == true:
		get_tree().change_scene_to_file("res://MainGame/Computer/computer_stocks.tscn")

func _on_bank_pressed():
	if storage.ComputerTutorial == true:
		get_tree().change_scene_to_file("res://MainGame/Computer/computer_bank.tscn")

func _on_return_button_pressed():
	if storage.ComputerTutorial == true:
		get_tree().change_scene_to_file("res://MainGame/main_game_bedroom.tscn")

func _on_tutorial_timer_timeout():
	storage.ComputerTutorial = true

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
